# frozen_string_literal: true

module YardSequel
  # Represents a Ruby Hash initialized from an Abstract Syntax Tree consisting
  # of `YARD::Parser::Ruby:AstNode`s.
  # @author Kai Moschcau
  class AstHash
    attr_accessor :ast

    def initialize(ast)
      check_ast ast
      @ast = ast
    end

    def to_h; end

    private

    def check_ast(ast)
      check_is_ast_node ast
      check_is_hash_or_list ast
      case ast.type
      when :hash then check_hash_children ast
      when :list then check_list_children ast
      end
    end

    def check_has_only_assoc_children(ast)
      return unless ast.children.any? { |child| child.type != :assoc }
      raise(ArgumentError,
            'all children of the passed `ast` have to have the type `:assoc`')
    end

    def check_hash_children(ast)
      return if ast.children.empty?
      check_has_only_assoc_children ast
    end

    def check_is_ast_node(ast)
      return if ast.is_a? YARD::Parser::Ruby::AstNode
      raise(TypeError,
            'the passed `ast` has to be a `YARD::Parser::Ruby::AstNode`')
    end

    def check_is_hash_or_list(ast)
      return if %i(hash list).include? ast.type
      raise(ArgumentError,
            "the passed `ast`'s type has to be `:hash` or `:list`")
    end

    def check_list_children(ast)
      if ast.children.empty?
        raise(ArgumentError,
              'a passed `ast` of type `:list` has to have children')
      end
      check_has_only_assoc_children ast
    end
  end
end
