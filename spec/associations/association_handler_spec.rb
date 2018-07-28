# frozen_string_literal: true

RSpec.describe YardSequel::Associations::AssociationHandler,
               '#association_name' do
  let :method do
    YardSequel::Associations::AssociationHandler.method :association_name
  end

  context 'passed a Symbol literal as first parameter' do
    let(:symbol) { :foo }
    let :method_call_node do
      YARD::Parser::Ruby::RipperParser.parse("method_call #{symbol.inspect}")
                                      .root[0]
    end

    it 'does not raise an error' do
      expect { method.call(method_call_node) }.not_to raise_error
    end

    it 'returns the Symbol literal as a String' do
      expect(method.call(method_call_node)).to eq symbol.to_s
    end
  end

  context 'passed a String as first parameter' do
    let :method_call_node do
      YARD::Parser::Ruby::RipperParser.parse('method_call "foo"').root[0]
    end

    it 'raises an AstNodeParseError' do
      expect { method.call(method_call_node) }
        .to raise_error(YardSequel::AstNodeParseError, /only parse Symbol/i)
    end
  end
end
