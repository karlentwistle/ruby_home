require "spec_helper"

RSpec.describe RubyHome::Uint8Value do
  describe "#default" do
    context "unit nil" do
      it "returns first default value from ValidValues" do
        template = double(constraints: {"ValidValues" => {"0" => "Inactive"}})
        handler = RubyHome::Uint8Value.new(template)
        expect(handler.default).to eql(0)
      end
    end

    context "unit percentage" do
      it "returns first default value MinimumValue" do
        template = double(constraints: {"MaximumValue" => 100, "MinimumValue" => 0, "StepValue" => 1})
        handler = RubyHome::Uint8Value.new(template)
        expect(handler.default).to eql(0)
      end
    end

    context "unit unknown" do
      it "raises an error" do
        template = double(constraints: {"UnknownValue" => 0})
        handler = RubyHome::Uint8Value.new(template)
        expect { handler.default }.to raise_error(RubyHome::UnknownValueError)
      end
    end
  end
end
