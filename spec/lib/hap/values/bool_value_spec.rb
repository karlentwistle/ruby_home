require "spec_helper"

RSpec.describe RubyHome::BoolValue do
  describe "#default" do
    it "returns false" do
      handler = RubyHome::BoolValue.new
      expect(handler.default).to eql(false)
    end
  end

  describe "value=" do
    it "assigns true as true" do
      handler = RubyHome::BoolValue.new
      handler.value = true
      expect(handler.value).to eql(true)
    end

    it "assigns 1 as true" do
      handler = RubyHome::BoolValue.new
      handler.value = 1
      expect(handler.value).to eql(true)
    end

    it "assigns '1' as true" do
      handler = RubyHome::BoolValue.new
      handler.value = "1"
      expect(handler.value).to eql(true)
    end

    it "assigns false as false" do
      handler = RubyHome::BoolValue.new
      handler.value = false
      expect(handler.value).to eql(false)
    end

    it "assigns 0 as false" do
      handler = RubyHome::BoolValue.new
      handler.value = 0
      expect(handler.value).to eql(false)
    end

    it "assigns '0' as false" do
      handler = RubyHome::BoolValue.new
      handler.value = "0"
      expect(handler.value).to eql(false)
    end
  end
end
