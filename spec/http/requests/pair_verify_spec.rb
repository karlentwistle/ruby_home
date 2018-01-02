require 'spec_helper'
require 'ed25519'
require_relative '../../../lib/rubyhome/tlv'

RSpec.describe "POST /pair-verify" do
  context 'Verify Start Response' do
    let(:session_key) do
      %w{
        BB295B9E B95A5917 2B66C0DB D5A66012 43A1A9C2 17F5BAB4 3F2947F4 0EF59521
        17931222 21BBA110 32002273 1B4F9162 701B73E3 B1C74C04 A758A5F6 B4541D71
      }.join.downcase
    end

    before do
      stub_secret_key = X25519::Scalar.new(['0000000000000000000000000000000000000000000000000000000000000040'].pack('H*'))
      allow(X25519::Scalar).to receive(:generate).and_return(stub_secret_key)

      Rubyhome::Cache.instance[:session_key] = session_key
      path = File.expand_path("../../../fixtures/verify_start_response", __FILE__)
      data = File.read(path)
      post '/pair-verify', data, { "CONTENT_TYPE" => "application/pairing+tlv8" }
    end

    it "headers contains application/pairing+tlv8 header" do
      expect(last_response.headers).to include('Content-Type' => 'application/pairing+tlv8')
    end

    it "body contains kTLVType_State" do
      expect(unpacked_body).to include('kTLVType_State' => 2)
    end

    it "body contains kTLVType_PublicKey" do
      public_key = unpacked_body['kTLVType_PublicKey']
      expected_public_key = %w{
        2FE57DA3 47CD6243 1528DAAC 5FBB2907 30FFF684 AFC4CFC2 ED90995F 58CB3B74
      }.join.downcase
      expect(public_key).to eql(expected_public_key)
    end

    it "body contains kTLVType_EncryptedData" do
      encrypted_data = unpacked_body['kTLVType_EncryptedData']
      expected_encrypted_data = %w{
        A1A9D22A D4DA0E65 EECCA820 A1872E4D 0F8EEAB6 38E37B44 A2228A43 4C305DAB
        AD057CD1 CD65B0C5 837DD92A 4B640CD7 D810D249 E666CAB1 3938CA59 FACB891C
        D7F5657E 6D2021E3 E2DF7ED0 7F0F14B5 7C3B5811 9869AFE1 5EE3C917 3F33D27A
        53923E4B 45
      }.join.downcase

      expect(encrypted_data).to eql(expected_encrypted_data)
    end
  end

  def unpacked_body
    @_unpacked_body ||= Rubyhome::TLV.unpack(last_response.body)
  end
end
