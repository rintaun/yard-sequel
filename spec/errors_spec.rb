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
