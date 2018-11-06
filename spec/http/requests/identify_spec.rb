require 'spec_helper'

RSpec.describe '/identify' do
  context 'POST' do
    context 'Request denied due to accessory being paired' do
      before do
        RubyHome::AccessoryInfo.instance.add_paired_client({
          admin: true,
          identifier: '349CBC7D-01B9-4DC4-AD98-FB9029BB77F2',
          public_key: '8d9686b698958af1497694003e07ff855358619f9633d62e40a6b55952716f17'
        })
      end

      it 'response headers contains application/hap+json' do
        post '/identify'
        expect(last_response.headers).to include('Content-Type' => 'application/hap+json')
      end

      it 'responds with a 400 Bad Request status code' do
        post '/identify'
        expect(last_response.status).to eql(400)
      end

      it 'response body includes status' do
        post '/identify'
        expect(last_response.body).to eql('{"status":-70401}')
      end
    end

    context 'unpaired accessory' do
      it 'responds with a 204 No Content HTTP status code' do
        post '/identify'
        expect(last_response.status).to eql(204)
      end
    end
  end
end

