# frozen_string_literal: true

module YardSequel
  module Associations
    # The handler class for Sequel many_to_one associations.
    # @author Kai Moschcau
    class ManyToOneHandler < YardSequel::Associations::AssociationHandler
      include YardSequel::Associations::DatasetMethod
      include YardSequel::Associations::ToOneMethods
      handles method_call :many_to_one
      handles method_call :one_to_one
      handles method_call :one_through_one
      namespace_only
      def process
        super
        orig_group = extra_state.group
        extra_state.group = "#{association_name.humanize} association"
        register(association_method_object, setter_method_object,
                 dataset_method_object)
        extra_state.group = orig_group
      end
    end
  end
end
