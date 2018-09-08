require_relative 'application_controller'

module RubyHome
  module HTTP
    class CharacteristicsController < ApplicationController
      get '/' do
        content_type 'application/hap+json'

        if cache[:controller_to_accessory_key] && cache[:accessory_to_controller_key]
          CharacteristicValueSerializer.new(find_characteristics).serialized_json
        else
          status 401
          JSON.generate({"status" => -70401})
        end
      end

      put '/' do
        content_type 'application/hap+json'

        if cache[:controller_to_accessory_key] && cache[:accessory_to_controller_key]
          json_body.fetch('characteristics', []).each do |characteristic_params|
            accessory_id = characteristic_params['aid']
            instance_id = characteristic_params['iid']
            characteristic = IdentifierCache.find_characteristics(
              accessory_id: accessory_id.to_i,
              instance_id: instance_id.to_i
            ).first

            if characteristic_params['value']
              characteristic.value = characteristic_params['value']
            end
          end

          status 204
        else
          status 401
          JSON.generate({"status" => -70401})
        end
      end

      private

        def find_characteristics
          params[:id].split(',').flat_map do |characteristic_params|
            accessory_id, instance_id = characteristic_params.split('.')
            IdentifierCache.find_characteristics(
              accessory_id: accessory_id.to_i,
              instance_id: instance_id.to_i
            )
          end
        end
    end
  end
end
