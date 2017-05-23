# frozen_string_literal: true

module YardSequel
  # The standard error for the plugin. All other errors inherit from this.
  # @author Kai Moschcau
  Error = Class.new ::StandardError

  # Error that is raised if anything goes wrong with parsing any AstNode.
  # @author Kai Moschcau
  class AstNodeParseError < Error
    # @return [YARD::Parser::Ruby::AstNode] the AstNode that caused the Error.
    attr_accessor :ast_node

    # @param [#to_s] message The message of the Error.
    # @param [YARD::Parser::Ruby::AstNode] ast_node The AstNode that caused the
    #   Error.
    def initialize(message = nil, ast_node = nil)
      @ast_node = ast_node
      super message
    end

    # @return [String] the message of the Error, with the location info of the
    #   AstNode prepended, if it exists.
    def message
      return super unless @ast_node
      [[ast_node_file, ast_node_line].compact.join(':'), super]
        .compact.join(': ')
    end

    private

    # @note This disables STDERR while getting the attribute.
    # @return [String, nil] the file name of the AstNode.
    def ast_node_file
      return unless @ast_node
      stderr    = $stderr
      $stderr   = StringIO.new
      file_name = @ast_node.file
      $stderr   = stderr
      file_name
    end

    # @return [String, nil] the line number of the AstNode.
    def ast_node_line
      return unless @ast_node && @ast_node.has_line?
      @ast_node.line
    end
  end

  # Error that is raised, when a AstNode could not be parsed into a usable
  # option value.
  # @author Kai Moschcau
  class OptionValueParseError < Error
    # @param [#to_s, YARD::Parser::Ruby::AstNode] message Either a message or
    #   the AstNode, that could not be parsed.
    # @param [String] file_name The file name to use. Overrides the one set in
    #   the AstNode, if one is passed.
    # @param [Integer] line_number The line number to use. Overrides the one set
    #   in the AstNode, if one is passed.
    def initialize(message = nil, file_name = nil, line_number = nil)
      super(case message
            when YARD::Parser::Ruby::AstNode
              message_from_ast_node(message, file_name, line_number)
            else
              message_from_string(message, file_name, line_number)
            end)
    end

    private

    # @param [YARD::Parser::Ruby::AstNode] message Either a message or the
    #   AstNode, that could not be parsed.
    # @param [String] file_name The file name to use. Overrides the one set in
    #   the AstNode, if one is passed.
    # @param [Integer] line_number The line number to use. Overrides the one set
    #   in the AstNode, if one is passed.
    def message_from_ast_node(message, file_name = nil, line_number = nil)
      location = [file_name || message.file,
                  line_number || message.line].compact.join(':')
      [(location unless /^\s*$/ =~ location),
       "Can't infer option value from a #{message.type} node"]
        .compact.join(': ')
    end

    # @param [#to_s] message The message to use.
    # @param [String] file_name The file name to use. Overrides the one set in
    #   the AstNode, if one is passed.
    # @param [Integer] line_number The line number to use. Overrides the one set
    #   in the AstNode, if one is passed.
    def message_from_string(message, file_name = nil, line_number = nil)
      location = [file_name, line_number].compact.join(':')
      [(location unless /^\s*$/ =~ location),
       message].compact.join(': ')
    end
  end
end
