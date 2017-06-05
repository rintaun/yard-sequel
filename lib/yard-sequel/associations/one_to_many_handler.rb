# frozen_string_literal: true

module YardSequel
  module Associations
    # The handler class for Sequel one_to_many associations.
    # @author Kai Moschcau
    class OneToManyHandler < YardSequel::Associations::AssociationHandler
      include YardSequel::Associations::DatasetMethod
      include YardSequel::Associations::ToManyMethods
      handles method_call :one_to_many
      namespace_only
      def process
        super
        register(association_method_object, adder_method_object,
                 clearer_method_object, remover_method_object,
                 dataset_method_object)
      end
    end
  end
end
