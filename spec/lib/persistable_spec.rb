require 'spec_helper'

RSpec.describe RubyHome::Persistable do
  class TestPersistable
    include RubyHome::Persistable

    def initialize(attributes)
      @attributes = attributes
    end

    attr_reader :attributes

    alias persisted_attributes attributes

    def ==(other)
      self.attributes == other.attributes
    end
  end

  describe '#save' do
    it 'writes persisted_attributes to file' do
      tempfile = Tempfile.new
      TestPersistable.source = tempfile

      TestPersistable.new({
        attribute_a: "attribute a value",
        attribute_b: "attribute b value"
      }).save

      tempfile.rewind
      expect(tempfile.read).to eql(
        <<~EXPECTED_RESULT
          ---
          :attribute_a: attribute a value
          :attribute_b: attribute b value
        EXPECTED_RESULT
      )
    end
  end

  describe '.persisted' do
    it 'reads attributes from file an initializes new class' do
      tempfile = Tempfile.new
      tempfile.write(
        <<~EXPECTED_RESULT
          ---
          :attribute_a: attribute a value
          :attribute_b: attribute b value
        EXPECTED_RESULT
      )
      TestPersistable.source = tempfile

      expect(TestPersistable.persisted).to eq(
        TestPersistable.new(
          attribute_a: 'attribute a value',
          attribute_b: 'attribute b value'
        )
      )
    end
  end
end
