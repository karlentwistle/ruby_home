require 'spec_helper'

RSpec.describe '/characteristics' do
  context 'GET' do
    context 'Request denied due to insufficient privileges' do
      before do
        get '/characteristics', nil, {'CONTENT_TYPE' => 'application/hap+json'}
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
  end

  context 'PUT' do
    context 'Request denied due to insufficient privileges' do
      before do
        put '/characteristics', nil, {'CONTENT_TYPE' => 'application/hap+json'}
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

    context 'sufficient privileges and no error occurs' do
      let(:valid_parameters) do
        JSON.generate({"characteristics" => [{"aid" => 2, "iid" => 10, "ev" => true}]})
      end

      before do
        set_cache(:controller_to_accessory_key, ['a' * 64].pack('H*'))
        set_cache(:accessory_to_controller_key, ['b' * 64].pack('H*'))
        put '/characteristics', valid_parameters, {'CONTENT_TYPE' => 'application/hap+json'}
      end

      it 'responds with a 204 No Content HTTP Status Code' do
        expect(last_response.status).to eql(204)
      end

      it 'responds with an empty body' do
        expect(last_response.body).to be_empty
      end
    end
  end
end
