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
  end
end
