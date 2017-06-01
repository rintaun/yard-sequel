RSpec.describe 'Album', '`many_to_one :artist` call:' do
  before do
    YARD::Registry.clear
    Dir.chdir(File.join(File.dirname(__FILE__), '..')) { YARD::Registry.load }
  end

  context '#artist' do
    let :method_object do
      YARD::Registry.all(:method).find { |o| o.name == :artist }
    end

    it 'exists as a method object' do
      expect(method_object).not_to be_nil
    end

    it 'is in the Album namespace' do
      expect(method_object.namespace.name).to be :Album
    end

    it 'is an instance method' do
      expect(method_object.scope).to be :instance
    end

    it 'has one return tag' do
      expect(method_object.tags.select { |t| t.tag_name == 'return' }.size)
        .to be 1
    end

    it "has return types 'Artist' and 'nil'" do
      expect(method_object.tags.find { |t| t.tag_name == 'return' }.types)
        .to contain_exactly 'Artist', 'nil'
    end
  end

  context '#artist=' do
    let :method_object do
      YARD::Registry.all(:method).find { |o| o.name == :artist= }
    end

    it 'exists as a method object' do
      expect(method_object).not_to be_nil
    end

    it 'is in the Album namespace' do
      expect(method_object.namespace.name).to be :Album
    end

    it 'is an instance method' do
      expect(method_object.scope).to be :instance
    end

    it 'has one return tag' do
      expect(method_object.tags.select { |t| t.tag_name == 'return' }.size)
        .to be 1
    end

    it "has return types 'Artist' and 'nil'" do
      expect(method_object.tags.find { |t| t.tag_name == 'return' }.types)
        .to contain_exactly 'Artist', 'nil'
    end
  end

  context '#artist_dataset' do
    let :method_object do
      YARD::Registry.all(:method).find { |o| o.name == :artist_dataset }
    end

    it 'exists as a method object' do
      expect(method_object).not_to be_nil
    end

    it 'is in the Album namespace' do
      expect(method_object.namespace.name).to be :Album
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
