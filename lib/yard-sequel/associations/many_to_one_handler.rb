# frozen_string_literal: true

module YardSequel
  module Associations
    # The handler class for Sequel many_to_one associations.
    # @author Kai Moschcau
    class ManyToOneHandler < YardSequel::Associations::AssociationHandler
      include YardSequel::Associations::DatasetMethod
      include YardSequel::Associations::ToOneMethods
      handles method_call :many_to_one
      namespace_only
      def process
        super
        register(association_method_object, setter_method_object,
                 dataset_method_object)
      end
    end
  end
end
