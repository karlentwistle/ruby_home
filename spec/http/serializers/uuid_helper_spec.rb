require "spec_helper"

RSpec.describe RubyHome::HTTP::UUIDHelper do
  class DummyClass
    include RubyHome::HTTP::UUIDHelper
  end

  describe ".uuid_short_form" do
    context "Apple Defined UUIDs" do
      {
        "00000001-0000-1000-8000-0026BB765291" => "1",
        "00000F25-0000-1000-8000-0026BB765291" => "F25",
        "0000BBAB-0000-1000-8000-0026BB765291" => "BBAB",
        "010004FF-0000-1000-8000-0026BB765291" => "10004FF",
        "FF000000-0000-1000-8000-0026BB765291" => "FF000000"
      }.each do |input, expected_output|
        context input do
          it "returns #{expected_output}" do
            expect(DummyClass.new.uuid_short_form(input)).to eql(expected_output)
          end
        end
      end
    end

    context "Custom UUID" do
      it "returns unmodified uuid" do
        uuid = "26ee707e-f6e6-4e02-b75a-eeb2eb0cfe0f"
        expect(DummyClass.new.uuid_short_form(uuid)).to eql(uuid)
      end
    end
  end
end
