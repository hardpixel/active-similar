# frozen_string_literal: true

module ActiveSimilar
  # Builds association subquery.
  class Association
    attr_reader :klass, :reflection, :other

    delegate :foreign_key, :through_reflection,
      to: :reflection

    delegate :klass, :name, :table_name, :foreign_key,
      to: :through_reflection,
      prefix: :through

    # Returns a new instance of Association.
    # @param name [Symbol]
    # @param klass [ActiveRecord::Base]
    # @param other [Integer ActiveRecord::Base]

    def initialize(name, klass, other)
      @klass      = klass
      @reflection = klass.reflect_on_association(name)
      @other      = other
    end

    # Returns the association join scope.
    # @return [ActiveRecord::Relation]
    def scope
      klass
        .joins(through_name)
        .where(through_table_name => { foreign_key => subquery })
    end

    private

    def subquery
      through_klass
        .select(foreign_key)
        .where(through_foreign_key => other)
    end
  end
end
