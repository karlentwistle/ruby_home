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
        fan = RubyHome::AccessoryFactory.create(:fan)
        characteristic = fan.characteristic(:on)

        iid = characteristic.instance_id
        aid = characteristic.accessory_id

        get '/characteristics', { id: [aid, iid].join('.') }, headers: { 'CONTENT_TYPE' => 'application/hap+json' }

        expect(last_response.status).to eql(200)
      end

      it 'responds with single characteristic' do
        fan = RubyHome::AccessoryFactory.create(:fan)
        characteristic = fan.characteristic(:on)

        iid = characteristic.instance_id
        aid = characteristic.accessory_id

        get '/characteristics', { id: [aid, iid].join('.') }, headers: { 'CONTENT_TYPE' => 'application/hap+json' }

        expected_data = { 'characteristics' => [{ 'aid' => aid, 'iid' => iid, 'value' => false }] }
        expect(last_response.body).to eql(JSON.generate(expected_data))
      end

      it 'responds with multiple characteristics' do
        garage_door_opener = RubyHome::AccessoryFactory.create(:garage_door_opener)
        characteristics = [
          garage_door_opener.characteristic(:current_door_state),
          garage_door_opener.characteristic(:target_door_state),
          garage_door_opener.characteristic(:obstruction_detected),
        ]
        characteristics_ids = characteristics.map do |characteristic|
          [characteristic.accessory_id, characteristic.instance_id].join('.')
        end

        get '/characteristics', { id: characteristics_ids.join(',') }, headers: { 'CONTENT_TYPE' => 'application/hap+json' }

        expect(JSON.parse(last_response.body)).to match(
          {
            'characteristics' => a_collection_containing_exactly(
              {
                'aid' => characteristics[0].accessory_id,
                'iid' => characteristics[0].instance_id,
                'value' => characteristics[0].value
              },
              {
                'aid' => characteristics[1].accessory_id,
                'iid' => characteristics[1].instance_id,
                'value' => characteristics[1].value
              },
              {
                'aid' => characteristics[2].accessory_id,
                'iid' => characteristics[2].instance_id,
                'value' => characteristics[2].value
              },
            )
          }
        )
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
      before do
        set_cache(:controller_to_accessory_key, ['a' * 64].pack('H*'))
        set_cache(:accessory_to_controller_key, ['b' * 64].pack('H*'))
      end

      it 'responds with a 204 No Content HTTP Status Code' do
        fan = RubyHome::AccessoryFactory.create(:fan)
        characteristic = fan.characteristic(:on)

        put '/characteristics', characteristic_parameters(characteristic => '1'), {'CONTENT_TYPE' => 'application/hap+json'}

        expect(last_response.status).to eql(204)
      end

      it 'responds with an empty body' do
        fan = RubyHome::AccessoryFactory.create(:fan)
        characteristic = fan.characteristic(:on)

        put '/characteristics', characteristic_parameters(characteristic => '1'), {'CONTENT_TYPE' => 'application/hap+json'}

        expect(last_response.body).to be_empty
      end

      it 'triggers single characteristic listeners' do
        fan = RubyHome::AccessoryFactory.create(:fan)
        characteristic = fan.characteristic(:on)
        listener = spy('listener')
        characteristic.subscribe(listener)

        put '/characteristics', characteristic_parameters(characteristic => '1'), {'CONTENT_TYPE' => 'application/hap+json'}

        expect(listener).to have_received(:after_update).with(characteristic)
      end

      it 'triggers multiple characteristics listeners' do
        garage_door_opener = RubyHome::AccessoryFactory.create(:garage_door_opener)
        obstruction_detected = garage_door_opener.characteristic(:obstruction_detected)
        target_door_state = garage_door_opener.characteristic(:target_door_state)
        obstruction_detected_listener = spy('listener')
        target_door_state_listener = spy('listener')
        obstruction_detected.subscribe(obstruction_detected_listener)
        target_door_state.subscribe(target_door_state_listener)

        put '/characteristics', characteristic_parameters(obstruction_detected => '1', target_door_state => '0'), {'CONTENT_TYPE' => 'application/hap+json'}

        expect(obstruction_detected_listener).to have_received(:after_update).with(obstruction_detected)
        expect(target_door_state_listener).to have_received(:after_update).with(target_door_state)
      end
    end
  end

  def characteristic_parameters(params)
    {
      'characteristics' => params.map do |characteristic, value|
        {
          'aid' => characteristic.accessory_id,
          'iid' => characteristic.instance_id,
          'value' => value
        }
      end
    }.to_json
  end
end
