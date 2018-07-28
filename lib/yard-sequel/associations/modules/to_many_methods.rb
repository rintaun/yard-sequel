# frozen_string_literal: true

module YardSequel
  module Associations
    # Provides methods for creating the to_many method objects.
    # @author Kai Moschcau
    module ToManyMethods
      # @return [YARD::CodeObjects::MethodObject] the adder MethodObject.
      def adder_method_object
        name             = association_name
        klass            = association_class || name.classify
        method           = method_object "add_#{name.singularize}"
        method.docstring += "Associates the passed #{klass} "\
                            'with `self`.'
        add_param_tag(method, name.singularize, klass,
                      "The #{klass} to associate with `self`.")
        return_tag(method, klass,
                   "the associated #{klass}.")
        method
      end

      # @return [YARD::CodeObjects::MethodObject] the association MethodObject.
      def association_method_object
        name   = association_name
        klass  = association_class || name.classify
        method = method_object name
        return_tag(method, "Array<#{klass}>",
                   "the associated #{klass.pluralize}.")
        method
      end

      # @return [YARD::CodeObjects::MethodObject] the clearer MethodObject.
      def clearer_method_object
        name             = association_name
        klass            = association_class || name.classify
        method           = method_object "remove_all_#{name}"
        method.docstring += 'Removes the association of all '\
                            "#{klass.pluralize} with `self`."
        void_return_tag method
        method
      end

      # @return [YARD::CodeObjects::MethodObject] the to_many remover
      #   method object.
      def remover_method_object
        name             = association_name
        klass            = association_class || name.classify
        method           = method_object "remove_#{name.singularize}"
        method.docstring += 'Removes the association of the passed '\
                            "#{klass} with `self`."
        add_param_tag(method, name.singularize, klass,
                      "The #{klass} to remove the association "\
                      'with `self` from.')
        void_return_tag method
        method
      end
    end
  end
end
