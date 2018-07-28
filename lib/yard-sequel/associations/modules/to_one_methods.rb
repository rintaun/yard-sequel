# frozen_string_literal: true

module YardSequel
  module Associations
    # Provides methods for creating the to_one method objects.
    # @author Kai Moschcau
    module ToOneMethods
      # @return [YARD::CodeObjects::MethodObject] the association MethodObject.
      def association_method_object
        name   = association_name
        klass  = association_class || name.classify
        method = method_object name
        return_tag(method, klass,
                   "the associated #{klass}.")
        method
      end

      # @return [YARD::CodeObjects::MethodObject] the setter MethodObject.
      def setter_method_object
        name             = association_name
        klass            = association_class || name.classify
        method           = method_object "#{name}="
        method.docstring += "Associates the passed #{klass} "\
                            'with `self`.'
        add_param_tag(method, name, klass,
                      "The #{klass} to associate with `self`.")
        return_tag(method, klass,
                   "the associated #{klass}.")
        method
      end
    end
  end
end
