require 'spec_helper'
require_relative '../../../lib/rubyhome/tlv'

RSpec.describe "POST /pairings" do
  context "Remove Pairing Response" do
    let(:controller_identifier) { "349CBC7D-01B9-4DC4-AD98-FB9029BB77F2" }
    let(:controller_public_key) do
      %w{
        D30CA02A 1118D736 4DF5372B 6C9D680C F140F3D7 A29413CC AC88D865 041E0C00
        A1186D59 56717363 E36AE5D0 6DCAFE6B A17A68E4 9A38EA37 E0848ACB D4EEFF09
      }.join.downcase
    end

    before do
      path = File.expand_path("../../../fixtures/remove_pairing_request", __FILE__)
      data = File.read(path)
      post '/pairings', data, {'CONTENT_TYPE' => 'application/pairing+tlv8'}
    end

    it "headers contains application/pairing+tlv8 header" do
      expect(last_response.headers).to include('Content-Type' => 'application/pairing+tlv8')
    end

    it "body contains kTLVType_State" do
      expect(unpacked_body['kTLVType_State']).to eql(2)
    end
  end

  def unpacked_body
    @_unpacked_body ||= Rubyhome::TLV.unpack(last_response.body)
  end
end
