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

    context 'sufficient privileges and no error occurs' do
      before do
        set_cache(:controller_to_accessory_key, ['a' * 64].pack('H*'))
        set_cache(:accessory_to_controller_key, ['b' * 64].pack('H*'))
      end

      it 'responds with a 204 No Content HTTP Status Code' do
        fan = Rubyhome::AccessoryFactory.create(:fan)
        characteristic = fan.characteristic(:on)

        iid = characteristic.instance_id
        aid = characteristic.accessory_id

        get '/characteristics', { id: [aid, iid].join('.') }, headers: { 'CONTENT_TYPE' => 'application/hap+json' }

        expect(last_response.status).to eql(200)
      end

      it 'responds with characteristics' do
        fan = Rubyhome::AccessoryFactory.create(:fan)
        characteristic = fan.characteristic(:on)

        iid = characteristic.instance_id
        aid = characteristic.accessory_id

        get '/characteristics', { id: [aid, iid].join('.') }, headers: { 'CONTENT_TYPE' => 'application/hap+json' }

        expected_data = { 'characteristics' => [{ 'aid' => aid, 'iid' => iid, 'value' => false }] }
        expect(last_response.body).to eql(JSON.generate(expected_data))
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
        JSON.generate({
          'characteristics' => [
            {
              'aid' => characteristic.accessory_id,
              'iid' => characteristic.instance_id,
              'value' => '1'
            }
          ]
        })
      end

      let(:characteristic) do
        Rubyhome::IdentifierCache.find_characteristics(uuid: '00000025-0000-1000-8000-0026BB765291').first
      end

      before do
        fan = Rubyhome::AccessoryFactory.create(:fan)
        set_cache(:controller_to_accessory_key, ['a' * 64].pack('H*'))
        set_cache(:accessory_to_controller_key, ['b' * 64].pack('H*'))
      end

      it 'responds with a 204 No Content HTTP Status Code' do
        put '/characteristics', valid_parameters, {'CONTENT_TYPE' => 'application/hap+json'}
        expect(last_response.status).to eql(204)
      end

      it 'responds with an empty body' do
        put '/characteristics', valid_parameters, {'CONTENT_TYPE' => 'application/hap+json'}
        expect(last_response.body).to be_empty
      end

      it 'triggers characteristic listeners' do
        listener = double('Listener')
        expect(listener).to receive(:updated).with('1')
        characteristic.subscribe(listener)
        put '/characteristics', valid_parameters, {'CONTENT_TYPE' => 'application/hap+json'}
      end
    end
  end
end
