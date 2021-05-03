require "spec_helper"

RSpec.describe RubyHome::HAP::Crypto::SessionKey do
  let(:shared_secret) { ["7cf0bcb855e8984de8224c4a1085d1ff3990339fa05036580ea98c085e7e2b1e"].pack("H*") }
  subject { described_class.new(shared_secret) }

  describe "controller_to_accessory_key" do
    context "with shared_secret set" do
      it "returns derived controller to accessory key" do
        expected_key = ["a8fa13bfec7a28b45a9abc8f82643853fee5ba04b052ee96c516f678b8978c7f"].pack("H*")
        expect(subject.controller_to_accessory_key).to eql(expected_key)
      end
    end
  end

  describe "accessory_to_controller_key" do
    context "with shared_secret set" do
      it "returns derived controller to accessory key" do
        expected_key = ["49b375d3b7a8b1176fafa7cceb874a9378a2b4279d26cc6b63a9f52832df0747"].pack("H*")
        expect(subject.accessory_to_controller_key).to eql(expected_key)
      end
    end
  end
end
