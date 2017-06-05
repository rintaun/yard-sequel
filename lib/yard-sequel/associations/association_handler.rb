# frozen_string_literal: true

module YardSequel
  module Associations
    # The basic DSL handler class for Sequel associations.
    # @author Kai Moschcau
    class AssociationHandler < YARD::Handlers::Ruby::DSLHandler
      class << self
        # @param [YARD::Parser::Ruby::MethodCallNode] statement The statement
        #   to get the association name from.
        # @return [String] the name of the association
        def association_name(statement)
          ast_node = statement.parameters.first
          unless ast_node.type == :symbol_literal
            raise(AstNodeParseError
                  .new('Can only parse Symbol literals as association names.',
                       ast_node))
          end
          ast_node.jump(:ident).source
        end
      end

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

      # @return (see .association_name)
      def association_name
        self.class.association_name @statement
      end

      # @return [Array<YARD::Parser::Ruby::AstNode>] the association nodes
      #   of the options Hash.
      def association_options
        @statement.parameters[1].filter { |node| node.type == :assoc }
      end

      # @param [String] name The name of the MethodObject.
      # @return [YARD::CodeObjects::MethodObject] a MethodObject.
      def method_object(name)
        method = YARD::CodeObjects::MethodObject.new(namespace, name)
        method[:sequel] = :association
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
    end
  end
end
