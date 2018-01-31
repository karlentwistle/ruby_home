require 'spec_helper'
require_relative '../../../lib/rubyhome/tlv'

RSpec.describe 'POST /pairings' do
  context 'Add Pairing' do
    before do
      path = File.expand_path('../../../fixtures/add_pairing_request', __FILE__)
      data = File.read(path)
      post '/pairings', data, {'CONTENT_TYPE' => 'application/pairing+tlv8'}
    end

    it 'headers contains application/pairing+tlv8 header' do
      expect(last_response.headers).to include('Content-Type' => 'application/pairing+tlv8')
    end

    it 'body contains kTLVType_State' do
      expect(unpacked_body['kTLVType_State']).to eql(2)
    end
  end

  context 'Remove Pairing Response' do
    before do
      path = File.expand_path('../../../fixtures/remove_pairing_request', __FILE__)
      data = File.read(path)
      post '/pairings', data, {'CONTENT_TYPE' => 'application/pairing+tlv8'}
    end

    it 'headers contains application/pairing+tlv8 header' do
      expect(last_response.headers).to include('Content-Type' => 'application/pairing+tlv8')
    end

    it 'body contains kTLVType_State' do
      expect(unpacked_body['kTLVType_State']).to eql(2)
    end
  end

  def unpacked_body
    @_unpacked_body ||= Rubyhome::TLV.unpack(last_response.body)
  end
end
