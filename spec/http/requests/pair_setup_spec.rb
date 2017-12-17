require_relative '../../../lib/rubyhome/tlv'

require 'spec_helper'

RSpec.describe "POST /pair-setup" do
  context "SRP Start Response" do
    before do
      path = File.expand_path("../../../fixtures/srp_start_request", __FILE__)
      data = File.read(path)
      post '/pair-setup', data
    end

    it "headers contains application/pairing+tlv8 header" do
      expect(last_response.headers).to include('Content-Type' => 'application/pairing+tlv8')
    end

    it "body contains kTLVType_State" do
      expect(unpacked_body).to include('kTLVType_State' => 2)
    end

    it "body contains kTLVType_Salt" do
      expect(unpacked_body).to include('kTLVType_Salt' => a_kind_of(String))
    end

    it "body contains kTLVType_Salt at least 31 in length" do
      salt = unpacked_body['kTLVType_Salt']
      expect(salt.length).to be >= 31
    end

    it "body contains kTLVType_PublicKey" do
      expect(unpacked_body).to include('kTLVType_PublicKey' => a_kind_of(String))
    end

    it "body contains kTLVType_PublicKey at least 766 in length" do
      public_key = unpacked_body['kTLVType_PublicKey']
      expect(public_key.length).to be >= 766
    end
  end

  context "SRP Verify Response" do
    before do
      path = File.expand_path("../../../fixtures/srp_verify_request", __FILE__)
      data = File.read(path)
      post '/pair-setup', data, { "CONTENT_TYPE" => "application/pairing+tlv8" }
    end

    it "headers contains application/pairing+tlv8 header" do
      expect(last_response.headers).to include('Content-Type' => 'application/pairing+tlv8')
    end

    it "body contains kTLVType_State" do
      expect(unpacked_body).to include('kTLVType_State' => 4)
    end

  end

  def unpacked_body
    @_unpacked_body ||= Rubyhome::TLV.unpack(last_response.body)
  end
end
