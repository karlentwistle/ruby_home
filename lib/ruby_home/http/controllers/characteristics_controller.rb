require_relative 'application_controller'

module RubyHome
  module HTTP
    class CharacteristicsController < ApplicationController
      before do
        content_type 'application/hap+json'
        require_session
      end

      get '/' do
        CharacteristicValueSerializer.new(find_characteristics).serialized_json
      end

      put '/' do
        json_body.fetch('characteristics', []).each do |characteristic_params|
          if characteristic_params['value']
            update_characteristics(characteristic_params)
          elsif characteristic_params['ev']
            subscribe_characteristics(characteristic_params)
          end
        end

        status 204
      end

      private

        def find_characteristics
          params.fetch(:id, "").split(',').flat_map do |characteristic_params|
            aid, iid = characteristic_params.split('.')
            find_characteristic(aid: aid, iid: iid)
          end
        end

        def update_characteristics(characteristic_params)
          find_characteristic(**characteristic_params.symbolize_keys.slice(:aid, :iid)) do |characteristic|
            characteristic.value = characteristic_params['value']
          end
        end

        def subscribe_characteristics(characteristic_params)
          find_characteristic(**characteristic_params.symbolize_keys.slice(:aid, :iid)) do |characteristic|
            characteristic.subscribe_socket(socket, :updated, async: true) do |new_value|
              serialized_characteristic = CharacteristicValueSerializer.new([characteristic]).serialized_json
              RubyHome::HAP::EVResponse.new(socket, serialized_characteristic).send_response
            end
          end
        end

        def find_characteristic(aid:, iid:)
          characteristic = IdentifierCache.find_characteristic(accessory_id: aid.to_i, instance_id: iid.to_i)
          yield characteristic if block_given?
          characteristic
        end

        def require_session
          unless cache[:controller_to_accessory_key] && cache[:accessory_to_controller_key]
            halt 401, JSON.generate({"status" => -70401})
          end
        end
    end
  end
end
