# frozen_string_literal: true

module YardSequel
  module Associations
    # Provides methods for creating the to_one method objects.
    # @author Kai Moschcau
    module ToOneMethods
      # @return [YARD::CodeObjects::MethodObject] the to_one getter method
      #   object.
      def create_to_one_getter
        name   = association_name
        klass  = association_class || name.classify
        method = create_method_object name
        return_tag(method, klass,
                   "the associated #{klass}.")
        method
      end

      # @return [YARD::CodeObjects::MethodObject] the to_one setter method
      #   object.
      def create_to_one_setter
        name             = association_name
        klass            = association_class || name.classify
        method           = create_method_object "#{name}="
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
