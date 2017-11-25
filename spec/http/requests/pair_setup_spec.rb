require_relative '../../../lib/rubyhome/tlv'

require 'spec_helper'

RSpec.describe "POST /pair-setup" do
  it "headers contains application/pairing+tlv8 header" do
    post '/pair-setup', "\x00\x01\x00\x06\x01\x01"
    expect(last_response.headers).to include('Content-Type' => 'application/pairing+tlv8')
  end

  it "body contains kTLVType_State" do
    post '/pair-setup', "\x00\x01\x00\x06\x01\x01"
    expect(unpacked_body).to include('kTLVType_State' => 2)
  end

  it "body contains kTLVType_Salt" do
    post '/pair-setup', "\x00\x01\x00\x06\x01\x01"
    expect(unpacked_body).to include('kTLVType_Salt' => a_kind_of(String))
  end

  it "body contains kTLVType_PublicKey" do
    post '/pair-setup', "\x00\x01\x00\x06\x01\x01"
    expect(unpacked_body).to include('kTLVType_PublicKey' => a_kind_of(String))
  end

  def unpacked_body
    @_unpacked_body ||= Rubyhome::TLV.unpack(last_response.body)
  end
end

