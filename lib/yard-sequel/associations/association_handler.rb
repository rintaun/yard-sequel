# frozen_string_literal: true

module YardSequel
  module Associations
    # The basic DSL handler class for Sequel associations.
    # @author Kai Moschcau
    class AssociationHandler < YARD::Handlers::Ruby::DSLHandler
      def process
        log.debug { "#{self.class.name}#process call" }
      end

      protected

      # Adds a parameter tag to a method object.
      # @param [YARD::CodeObjects::MethodObject] method
      #   The method to add the parameter tag to.
      # @param [String] name The name of the parameter.
      # @param [String] class_name The class name of the parameter.
      # @param [String] description The description of the parameter.
      # @return [void]
      def add_param_tag(method, name, class_name, description)
        method.parameters << [name, nil]
        method.docstring.add_tag(
          YARD::Tags::Tag.new(:param, description, class_name, name)
        )
      end

      # @return [String] the name of the association
      def association_name
        @statement.parameters.first.jump(:ident).source
      end

      # @return [Array<YARD::Parser::Ruby::AstNode>] the association nodes
      #   of the options Hash.
      def association_options
        s = @statement.parameters[1] || return
        s = s.select { |node| node.type == :assoc } || return
        AstNodeHash.from_ast(@statement.parameters[1])
      end

      def association_class
        return unless opt = association_options
        ret = nil
        ret = opt.select do |k, v|
          while k.respond_to? :last
            k = k.last
          end
          next unless k.is_a?(String) && k.downcase == 'class'
          while v.respond_to? :last
            v = v.last
          end
          break v
        end
        ret unless ret.empty?
      end

      # @param [String] name The name of the method object.
      # @return [YARD::CodeObjects::MethodObject] a method object.
      def create_method_object(name)
        method = YARD::CodeObjects::MethodObject.new(namespace, name)
        register_and_tag method
        method
      end

      # Sets or replaces the return tag on a passed method object.
      # @param (see #void_return_tag)
      # @param [String] class_name The class name of the return value.
      # @param [String] description The description of the return value.
      # @return (see #void_return_tag)
      def return_tag(method, class_name, description)
        method.docstring.delete_tags(:return)
        method.docstring.add_tag(
          YARD::Tags::Tag.new(:return, description, class_name)
        )
      end

      # Sets or replaces the return tag on a passed method object with a
      # void return tag.
      # @param [YARD::CodeObjects::MethodObject] method
      #   The method object to set the return tag on.
      # @return [void]
      def void_return_tag(method)
        method.docstring.delete_tags(:return)
        method.docstring.add_tag(
          YARD::Tags::Tag.new(:return, nil, 'void')
        )
      end

      private

      # Registers the source of a given method object and sets some tags.
      # @param [YARD::CodeObjects::MethodObject] method
      #   The method object to register and tag.
      # @return [void]
      def register_and_tag(method)
        unless method.is_a? YARD::CodeObjects::MethodObject
          raise(ArgumentError, 'The given method has to be a ' +
            YARD::CodeObjects::MethodObject.to_s)
        end
        register method
        method.dynamic  = true
        method[:sequel] = :association
      end
    end
  end
end
