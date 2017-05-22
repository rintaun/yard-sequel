# frozen_string_literal: true

module YardSequel
  module Associations
    # Handles association options and makes them easily accessible.
    # @author Kai Moschcau
    class AssociationOptions
      # The node types option values can be parsed from.
      NODE_TYPES  = %i[const_path_ref
                       string_literal
                       symbol_literal
                       top_const_ref
                       var_ref].freeze

      # The option keys that will be looked for.
      OPTION_KEYS = %w[class
                       class_namespace
                       join_table
                       read_only].freeze

      # @return [String] the Class name option.
      attr_reader :class_option

      # @return [String] the Class namespace option.
      attr_reader :class_namespace_option

      # @return [String] the join table name option.
      attr_reader :join_table_option

      # @return [Boolean] the read only option.
      attr_reader :read_only_option

      class << self
        def value_from_const_path_ref(ast_node)
          ast_node.source
        end

        def value_from_label(ast_node)
          ast_node.source.gsub(/:$/, '')
        end

        def value_from_node(ast_node)
          raise(OptionValueParseError, ast_node) unless
            NODE_TYPES.include? ast_node.type
          send(:"value_from_#{ast_node.type}", ast_node)
        end

        def value_from_string_literal(ast_node)
          if ast_node[0].children.any? { |cn| cn.type == :string_embexpr }
            raise(OptionValueParseError.new("Can't parse String interpolation",
                                            ast_node.file, ast_node.line))
          end
          ast_node.jump(:tstring_content).source
        end

        def value_from_symbol_literal(ast_node)
          ast_node.jump(:ident, :const).source
        end

        def value_from_top_const_ref(ast_node)
          ast_node.source
        end

        def value_from_var_ref(ast_node)
          ast_node.jump(:const).source
        end
      end

      def initialize(ast_node_hash)
        ast_node_hash.each do |key, value|
          key_name = self.class.value_from_label key
          next unless OPTION_KEYS.include? key_name
          instance_variable_set(:"@#{key_name}_option",
                                self.class.value_from_node(value))
        end
      end
    end
  end
end
