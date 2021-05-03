require_relative "application_controller"

module RubyHome
  module HTTP
    class CharacteristicsController < ApplicationController
      before do
        content_type "application/hap+json"
        require_session
      end

      get "/" do
        CharacteristicValueSerializer.new(find_characteristics).serialized_json
      end

      put "/" do
        json_body.fetch("characteristics", []).each do |characteristic_params|
          if characteristic_params.key?("value")
            update_characteristics(characteristic_params)
          elsif characteristic_params.key?("ev")
            subscribe_characteristics(characteristic_params)
          end
        end

        status 204
      end

      private

      def find_characteristics
        params.fetch(:id, "").split(",").flat_map do |characteristic_params|
          aid, iid = characteristic_params.split(".")
          find_characteristic(aid: aid, iid: iid)
        end
      end

      def update_characteristics(characteristic_params)
        find_characteristic(**characteristic_params.symbolize_keys.slice(:aid, :iid)) do |characteristic|
          characteristic.value = characteristic_params["value"]
        end
      end

      def subscribe_characteristics(characteristic_params)
        find_characteristic(**characteristic_params.symbolize_keys.slice(:aid, :iid)) do |characteristic|
          notifier = SessionNotifier.new(session, characteristic)

          unless characteristic.listeners.include?(notifier)
            characteristic.subscribe(notifier)
          end
        end
      end

      def find_characteristic(aid:, iid:)
        characteristic = identifier_cache.find_characteristic(accessory_id: aid.to_i, instance_id: iid.to_i)
        yield characteristic if block_given?
        characteristic
      end

      def require_session
        unless session.sufficient_privileges?
          halt 401, JSON.generate({"status" => -70401})
        end
      end
    end
  end
end
