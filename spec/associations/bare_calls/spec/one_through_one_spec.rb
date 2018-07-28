RSpec.describe 'Artist', '`one_through_one :album` call:' do
  before do
    YARD::Registry.clear
    Dir.chdir(File.join(File.dirname(__FILE__), '..')) { YARD::Registry.load }
  end

  context '#album' do
    let :method_object do
      YARD::Registry.all(:method).find { |o| o.name == :album }
    end

    it 'exists as a method object' do
      expect(method_object).not_to be_nil
    end

    it 'is in the Artist namespace' do
      expect(method_object.namespace.name).to be :Artist
    end

    it 'is an instance method' do
      expect(method_object.scope).to be :instance
    end

    it 'has one return tag' do
      expect(method_object.tags.select { |t| t.tag_name == 'return' }.size)
        .to be 1
    end

    it "has return types 'Album' and 'nil'" do
      expect(method_object.tags.find { |t| t.tag_name == 'return' }.types)
        .to contain_exactly 'Album', 'nil'
    end
  end

  context '#album=' do
    let :method_object do
      YARD::Registry.all(:method).find { |o| o.name == :album= }
    end

    it 'exists as a method object' do
      expect(method_object).not_to be_nil
    end

    it 'is in the Artist namespace' do
      expect(method_object.namespace.name).to be :Artist
    end

    it 'is an instance method' do
      expect(method_object.scope).to be :instance
    end

    it 'has one return tag' do
      expect(method_object.tags.select { |t| t.tag_name == 'return' }.size)
        .to be 1
    end

    it "has return types 'Album' and 'nil'" do
      expect(method_object.tags.find { |t| t.tag_name == 'return' }.types)
        .to contain_exactly 'Album', 'nil'
    end
  end

  context '#album_dataset' do
    let :method_object do
      YARD::Registry.all(:method).find { |o| o.name == :album_dataset }
    end

    it 'exists as a method object' do
      expect(method_object).not_to be_nil
    end

    it 'is in the Artist namespace' do
      expect(method_object.namespace.name).to be :Artist
    end

    it 'is an instance method' do
      expect(method_object.scope).to be :instance
    end

    it 'has one return tag' do
      expect(method_object.tags.select { |t| t.tag_name == 'return' }.size)
        .to be 1
    end

    it "has a return type of 'Sequel::Dataset'" do
      expect(method_object.tags.find { |t| t.tag_name == 'return' }.types)
        .to contain_exactly 'Sequel::Dataset'
    end
  end
end
