# frozen_string_literal: true

require 'active_similar/association'

module ActiveSimilar
  # Queries similar models through most common associations.
  class Query
    attr_reader :scope, :through, :prefix

    delegate :klass, :table, :select_values,
      to: :scope

    delegate :primary_key, :column_names,
      to: :klass

    # Returns a new instance of Query.
    # @param scope [ActiveRecord::Relation]
    # @param through [Symbol Array<Symbol>]
    # @param prefix [String]
    # @raise [TypeError] if scope has invalid type

    def initialize(scope, through:, prefix: 'similar')
      relation = ActiveRecord::Relation
      scope.is_a?(relation) || raise(TypeError, "scope must be #{relation}")

      @scope   = scope
      @through = Array(through)
      @prefix  = prefix
    end

    # Returns records similar to other record.
    # @param other [Integer ActiveRecord::Base]
    # @return [ActiveRecord::Relation]

    def with(other)
      scope
        .merge(subquery(other))
        .where.not(primary_key => other)
        .select(*select_columns)
        .group(*group_columns)
        .order(count_column => :desc)
    end

    def inspect # :nodoc:
      "#<#{self.class.name} model=#{klass.name} through=#{through} prefix=#{prefix}>"
    end

    private

    def count_column
      "#{prefix}_#{table.name}_count"
    end

    def columns
      names  = column_names
      names &= select_values.map(&:to_s) if select_values.any?

      names
    end

    def group_columns
      columns.map { |col| table[col] }
    end

    def select_columns
      counter  = table[primary_key].count.as(count_column)
      clauses  = [counter.to_sql]
      clauses << table[Arel.star] if select_values.none?

      clauses
    end

    def build_association(name, other)
      assoc = Association.new(name, klass, other)
      return assoc.scope if select_values.none?

      assoc.scope.select(*group_columns)
    end

    def build_union(left, right)
      left  = Arel::Nodes::Grouping.new(left.arel.ast)
      right = Arel::Nodes::Grouping.new(right.arel.ast)

      klass.unscoped.from(
        Arel::Nodes::TableAlias.new(
          Arel::Nodes::UnionAll.new(left, right),
          table.name
        )
      )
    end

    def subquery(other)
      items = through.map { |name| build_association(name, other) }
      query = items.delete_at(0)

      items.each do |item|
        query = build_union(query, item)
      end

      query
    end
  end
end
