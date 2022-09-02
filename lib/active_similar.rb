# frozen_string_literal: true

require 'active_record'

require 'active_similar/query'
require 'active_similar/version'

# Find similar Active Record models through most common associations.
module ActiveSimilar
  extend ActiveSupport::Concern

  class_methods do
    # Defines method to retrieve similar records.
    # @param name [Symbol]
    # @param through [Symbol Array<Symbol>]
    # @param class_name [ActiveRecord::Base]
    # @param scope [Symbol]

    def has_similar(name, through:, class_name: self, scope: :all)
      klass = const_get(class_name.to_s)
      scope = klass.send(scope)

      define_method(name) do
        similar = Query.new(scope, through: through, prefix: name)
        similar.with(id)
      end
    end
  end
end
