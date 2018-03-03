require 'spec_helper'

RSpec.describe 'GET /accessories' do
  context 'Request denied due to insufficient privileges' do
    before do
      get '/accessories', nil, {'CONTENT_TYPE' => 'application/hap+json'}
    end

    it 'headers contains application/hap+json' do
      expect(last_response.headers).to include('Content-Type' => 'application/hap+json')
    end

    it 'response status 401' do
      expect(last_response.status).to eql(401)
    end

    it 'response body includes status' do
      expect(last_response.body).to eql('{"status":-70401}')
    end
  end

  context 'Sufficient privileges and no error occurs' do
    before do
      set_cache(:controller_to_accessory_key, ['a' * 64].pack('H*'))
      set_cache(:accessory_to_controller_key, ['b' * 64].pack('H*'))
      get '/accessories', nil, {'CONTENT_TYPE' => 'application/hap+json'}
    end

    it 'headers contains application/hap+json' do
      expect(last_response.headers).to include('Content-Type' => 'application/hap+json')
    end

    it 'response status 200' do
      expect(last_response.status).to eql(200)
    end

    it 'responds with accessories' do
      path = File.expand_path('../../../../lib/rubyhome/http/public/example_accessory.json', __FILE__)
      data = File.read(path)
      expect(last_response.body).to eql(data)
    end
  end
end
