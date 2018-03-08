require_relative 'application_controller'
require_relative '../serializers/characteristic_value_serializer'

module Rubyhome
  module HTTP
    class CharacteristicsController < ApplicationController
      get '/characteristics' do
        content_type 'application/hap+json'

        if cache[:controller_to_accessory_key] && cache[:accessory_to_controller_key]
          accessory_id, instance_id = params[:id].split('.')

          characteristics = Characteristic.where(accessory_id: accessory_id, instance_id: instance_id)
          CharacteristicValueSerializer.new(characteristics).serialized_json
        else
          status 401
          JSON.generate({"status" => -70401})
        end
      end

      put '/characteristics' do
        content_type 'application/hap+json'

        if cache[:controller_to_accessory_key] && cache[:accessory_to_controller_key]
          status 204
        else
          status 401
          JSON.generate({"status" => -70401})
        end
      end
    end
  end
end
