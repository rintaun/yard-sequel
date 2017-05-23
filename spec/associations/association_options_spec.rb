# frozen_string_literal: true

RSpec.describe YardSequel::Associations::AssociationOptions, '.new passed' do
  method = YardSequel::Associations::AssociationOptions.method(:new)

  context 'a AstNodeHash with "class" key' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse('{ class: Foo }').root[0]
    ast_node_hash = YardSequel::AstNodeHash.from_ast ast_node

    it 'sets the @class_option instance variable' do
      expect(method.call(ast_node_hash).class_option).to eq 'Foo'
    end
  end

  context 'a AstNodeHash with "class_namespace" key' do
    ast_node = YARD::Parser::Ruby::RipperParser
               .parse('{ class_namespace: Foo }').root[0]
    ast_node_hash = YardSequel::AstNodeHash.from_ast ast_node

    it 'sets the @class_namespace_option instance variable' do
      expect(method.call(ast_node_hash).class_namespace_option).to eq 'Foo'
    end
  end

  context 'a AstNodeHash with "join_table" key' do
    ast_node = YARD::Parser::Ruby::RipperParser
               .parse('{ join_table: Foo }').root[0]
    ast_node_hash = YardSequel::AstNodeHash.from_ast ast_node

    it 'sets the @join_table_option instance variable' do
      expect(method.call(ast_node_hash).join_table_option).to eq 'Foo'
    end
  end

  context 'a AstNodeHash with "read_only" key' do
    ast_node = YARD::Parser::Ruby::RipperParser
               .parse('{ read_only: Foo }').root[0]
    ast_node_hash = YardSequel::AstNodeHash.from_ast ast_node

    it 'sets the @read_only_option instance variable' do
      expect(method.call(ast_node_hash).read_only_option).to eq 'Foo'
    end
  end
end

RSpec.describe YardSequel::Associations::AssociationOptions,
               '.value_from_const_path_ref passed' do
  method = YardSequel::Associations::AssociationOptions
           .method(:value_from_const_path_ref)

  context 'a const_path_ref AstNode' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse('Foo::Bar').root[0]

    it 'returns the source of the constant path reference' do
      expect(method.call(ast_node)).to eq 'Foo::Bar'
    end
  end
end

RSpec.describe YardSequel::Associations::AssociationOptions,
               '.value_from_label passed' do
  method = YardSequel::Associations::AssociationOptions
           .method(:value_from_label)

  context 'a label AstNode' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse('{ foo: :bar }')
                                               .root[0][0][0]

    it 'returns the name of the label' do
      expect(method.call(ast_node)).to eq 'foo'
    end
  end
end

RSpec.describe YardSequel::Associations::AssociationOptions,
               '.value_from_node passed' do
  klass  = YardSequel::Associations::AssociationOptions
  method = klass.method(:value_from_node)

  context 'a const_path_ref AstNode' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse('Foo::Bar').root[0]

    it 'calls the "value_from_const_path_ref" method' do
      expect(klass).to receive(:value_from_const_path_ref).with ast_node
      method.call ast_node
    end
  end

  context 'a label AstNode' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse('{ foo: :bar }')
                                               .root[0][0][0]

    it 'raises an OptionValueParseError' do
      expect { method.call(ast_node) }
        .to raise_error YardSequel::AstNodeParseError,
                        /can't infer option value from a \w+ node/i
    end
  end

  context 'a string_literal AstNode' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse("'Foo'").root[0]

    it 'calls the "value_from_string_literal" method' do
      expect(klass).to receive(:value_from_string_literal).with ast_node
      method.call ast_node
    end
  end

  context 'a symbol_literal AstNode' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse(':foo').root[0]

    it 'calls the "value_from_symbol_literal" method' do
      expect(klass).to receive(:value_from_symbol_literal).with ast_node
      method.call ast_node
    end
  end

  context 'a top_const_ref AstNode' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse('::Foo').root[0]

    it 'calls the "value_from_top_const_ref" method' do
      expect(klass).to receive(:value_from_top_const_ref).with ast_node
      method.call ast_node
    end
  end

  context 'a var_ref AstNode' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse('Foo').root[0]

    it 'calls the "value_from_var_ref" method' do
      expect(klass).to receive(:value_from_var_ref).with ast_node
      method.call ast_node
    end
  end
end

RSpec.describe YardSequel::Associations::AssociationOptions,
               '.value_from_string_literal passed' do
  method = YardSequel::Associations::AssociationOptions
           .method(:value_from_string_literal)

  context 'a string_literal AstNode with interpolation' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse('"foo#{baz}bar"').root[0]

    it 'raises an OptionValueParseError' do
      expect { method.call(ast_node) }
        .to raise_error YardSequel::AstNodeParseError, /string interpolation/i
    end
  end

  context 'a string_literal AstNode' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse("'Foo'").root[0]

    it 'returns the String content of the AstNode' do
      expect(method.call(ast_node)).to eq 'Foo'
    end
  end
end

RSpec.describe YardSequel::Associations::AssociationOptions,
               '.value_from_symbol_literal passed' do
  method = YardSequel::Associations::AssociationOptions
           .method(:value_from_symbol_literal)

  context 'a symbol_literal AstNode with a capitalized word' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse(':Foo').root[0]

    it 'returns the String content of the AstNode' do
      expect(method.call(ast_node)).to eq 'Foo'
    end
  end

  context 'a symbol_literal AstNode with a non-capitalized word' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse(':foo').root[0]

    it 'returns the String content of the AstNode' do
      expect(method.call(ast_node)).to eq 'foo'
    end
  end
end

RSpec.describe YardSequel::Associations::AssociationOptions,
               '.value_from_top_const_ref passed' do
  method = YardSequel::Associations::AssociationOptions
           .method(:value_from_top_const_ref)

  context 'a top_const_ref AstNode' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse('::Bar').root[0]

    it 'returns the source of the top constant reference' do
      expect(method.call(ast_node)).to eq '::Bar'
    end
  end
end

RSpec.describe YardSequel::Associations::AssociationOptions,
               '.value_from_var_ref passed' do
  method = YardSequel::Associations::AssociationOptions
           .method(:value_from_var_ref)

  context 'a var_ref AstNode' do
    ast_node = YARD::Parser::Ruby::RipperParser.parse('Foo').root[0]

    it 'returns the name of the constant' do
      expect(method.call(ast_node)).to eq 'Foo'
    end
  end
end
