# frozen_string_literal: true

RSpec.describe YardSequel::AstNodeParseError, '#message' do
  ast_node = YARD::Parser::Ruby::RipperParser.parse(':foo').root[0]
  message  = 'this is a message'

  context 'initialized without a parameter' do
    error = YardSequel::AstNodeParseError.new

    it 'returns the class name' do
      expect(error.message).to eq YardSequel::AstNodeParseError.name
    end
  end

  context 'initialized with a message' do
    error = YardSequel::AstNodeParseError.new(message)

    it 'returns the message' do
      expect(error.message).to be message
    end
  end

  context 'initialized with only an AstNode' do
    error = YardSequel::AstNodeParseError.new(nil, ast_node)

    it 'returns the location info with the class name' do
      expect(error.message)
        .to eq [[ast_node.file, ast_node.line].join(':'),
                YardSequel::AstNodeParseError.name].join(': ')
    end
  end

  context 'initialized with a message and an AstNode' do
    error = YardSequel::AstNodeParseError.new(message, ast_node)

    it 'returns the message with location info' do
      expect(error.message)
        .to eq [[ast_node.file, ast_node.line].join(':'), message].join(': ')
    end
  end
end

RSpec.describe YardSequel::OptionValueParseError, '.new passed' do
  context 'passed an AstNode' do
    file_name   = 'foo.rb'
    line_number = 42
    ast_node    = YARD::Parser::Ruby::RipperParser
                  .parse("'foo'", file_name, line_number).root[0]

    it 'generates a message' do
      expect(YardSequel::OptionValueParseError.new(ast_node).message)
        .to eq([file_name,
                line_number,
                " Can't infer option value from a #{ast_node.type} node"]
                 .join(':'))
    end
  end

  context 'passed an AstNode with file name and line number' do
    file_name   = 'bar.rb'
    line_number = 3
    ast_node    = YARD::Parser::Ruby::RipperParser.parse("'foo'").root[0]

    it 'generates a message' do
      expect(YardSequel::OptionValueParseError
               .new(ast_node, file_name, line_number).message)
        .to eq([file_name,
                line_number,
                " Can't infer option value from a #{ast_node.type} node"]
                 .join(':'))
    end
  end

  context 'a String' do
    it 'uses the String as message' do
      expect(YardSequel::OptionValueParseError.new('foo').message).to eq 'foo'
    end
  end

  context 'a String with file name and line number' do
    file_name   = 'baz.rb'
    line_number = 56

    it 'uses the String message, the file name and the line number' do
      expect(YardSequel::OptionValueParseError.new('foo', file_name,
                                                   line_number).message)
        .to eq [file_name, line_number, ' foo'].join(':')
    end
  end
end
