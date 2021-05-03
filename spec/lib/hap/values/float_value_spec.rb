require "spec_helper"

RSpec.describe RubyHome::FloatValue do
  describe "#default" do
    it "returns minimum value from template constraints" do
      template = double(constraints: {"MinimumValue" => 10})
      handler = RubyHome::FloatValue.new(template)
      expect(handler.default).to eql(10.0)
    end
  end
end
