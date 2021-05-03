require "spec_helper"

RSpec.describe RubyHome::Int32Value do
  describe "#default" do
    it "returns minimum value from template constraints" do
      template = double(constraints: {"MinimumValue" => 10})
      handler = RubyHome::Int32Value.new(template)
      expect(handler.default).to eql(10)
    end
  end
end
