require 'spec_helper'

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

    it 'creates pairing record' do
      expect(RubyHome::AccessoryInfo.paired_clients).to match(
        a_hash_including(
          admin: true,
          identifier: '1CCBFFE2-C15B-4C47-B722-B7F22D2EC5EB',
          public_key: '8d9686b698958af1497694003e07ff855358619f9633d62e40a6b55952716f17'
        )
      )
    end
  end

  context 'Remove Pairing Response' do
    before do
      RubyHome::AccessoryInfo.add_paired_client({
        admin: true,
        identifier: '349CBC7D-01B9-4DC4-AD98-FB9029BB77F2',
        public_key: '8d9686b698958af1497694003e07ff855358619f9633d62e40a6b55952716f17'
      })
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

    it 'remove all pairing records' do
      expect(RubyHome::AccessoryInfo.paired_clients).to be_empty
    end
  end
end
