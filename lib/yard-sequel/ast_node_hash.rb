# frozen_string_literal: true

module YardSequel
  # Offers methods to convert an Abstract Syntax Tree to a Hash consisting
  # of `YARD::Parser::Ruby::AstNode`s.
  # @author Kai Moschcau
  module AstNodeHash
    class << self
      # @param [YARD::Parser::Ruby::AstNode] ast_node The AstNode to create the
      #   Hash from.
      # @return [Hash{YARD::Parser::Ruby::AstNode=>YARD::Parser::Ruby::AstNode}]
      #   a Hash with AstNodes as keys and values.
      def from_ast(ast_node)
        check_ast ast_node
        node_hash_from_node ast_node
      end

      # Checks the passed AstNode, if it can be converted to an AstNode Hash.
      # It will raise AstNodeParseErrors, if not.
      # @param [YARD::Parser::Ruby::AstNode] ast_node The AstNode to check, if
      #   it can be converted to an AstNode Hash.
      # @return [void]
      def check_ast(ast_node)
        check_is_ast_node ast_node
        check_is_hash_or_list ast_node
        case ast_node.type
        when :hash then check_hash_children ast_node
        when :list then check_list_children ast_node
        end
      end

      private

      # Checks if the passed `:assoc` type node has exactly two children.
      # @param [YARD::Parser::Ruby::AstNode] assoc_node The AstNode to check.
      # @raise [AstNodeParseError] If the passed AstNode does not have exactly
      #   two children.
      # @return [nil]
      def check_assoc_child_has_two_children(assoc_node)
        return if assoc_node.children.size == 2
        raise(AstNodeParseError.new(
                'each `:assoc` child must have two children', assoc_node
        ))
      end

      # Checks the passed AstNode's children.
      # @param (see .check_assoc_child_has_two_children)
      # @return [void]
      def check_children(ast_node)
        check_has_only_assoc_children ast_node
        ast_node.children.each do |child_ast|
          check_assoc_child_has_two_children child_ast
        end
      end

      # Checks if the passed AstNode has only children of type `:assoc`.
      # @param (see .check_assoc_child_has_two_children)
      # @raise [AstNodeParseError] If there are child nodes, that are not of the
      #   `:assoc` type.
      # @return [void]
      def check_has_only_assoc_children(ast_node)
        ast_node.children.each do |child_node|
          next unless child_node.type != :assoc
          raise(AstNodeParseError.new(
                  'all children have to have the type `:assoc`', child_node
          ))
        end
      end

      # Checks the children of a `:hash` type AstNode.
      # @param (see .check_assoc_child_has_two_children)
      # @return [void]
      def check_hash_children(ast_node)
        return if ast_node.children.empty?
        check_children ast_node
      end

      # Checks if the passed Object is an AstNode.
      # @param (see .check_assoc_child_has_two_children)
      # @raise [AstNodeParseError] If the passed Object is not an AstNode.
      # @return [nil]
      def check_is_ast_node(ast_node)
        return if ast_node.is_a? YARD::Parser::Ruby::AstNode
        raise(AstNodeParseError,
              'the passed Object has to be a `YARD::Parser::Ruby::AstNode`')
      end

      # Checks if the passed AstNode's type is either `:hash` or `:list`.
      # @param (see .check_assoc_child_has_two_children)
      # @raise [AstNodeParseError] If the passed AstNode is none one of the two
      #   types.
      # @return [nil]
      def check_is_hash_or_list(ast_node)
        return if %i[hash list].include? ast_node.type
        raise(AstNodeParseError.new(
                "the passed ast_node's type has to be `:hash` or `:list`",
                ast_node
        ))
      end

      # Checks the children of a `:list` type AstNode.
      # @param (see .check_assoc_child_has_two_children)
      # @raise [AstNodeParseError] If the passed AstNode has no children.
      # @return [void]
      def check_list_children(ast_node)
        if ast_node.children.empty?
          raise(AstNodeParseError.new(
                  'a passed `ast` of type `:list` has to have children',
                  ast_node
          ))
        end
        check_children ast_node
      end

      # @param [YARD::Parser::Ruby::AstNode] ast_node The AstNode to create
      #   the AstNode Hash from.
      # @return [Hash{YARD::Parser::Ruby::AstNode=>YARD::Parser::Ruby::AstNode}]
      #   an AstNode Hash.
      def node_hash_from_node(ast_node)
        hash = {}
        ast_node.children.each { |cn| hash[cn.children[0]] = cn.children[1] }
        hash
      end
    end
  end
end
