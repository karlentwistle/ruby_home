require 'webrick/httpresponse'
require_relative '../counter'
require_relative '../hap/http_encryption'

module Rubyhome
  module HTTP
    class HAPResponse < WEBrick::HTTPResponse
      def send_response(socket)
        if encryption_time?
          response = String.new
          super(response)

          encrypted_response = encrypter.encrypt(response).join
          accessory_to_controller_count_increment(encrypter.count)

          _write_data(socket, encrypted_response)
        else
          super(socket)
        end
      end

      private

      def encrypter
        @_encrypter ||= Rubyhome::HAP::HTTPEncryption.new(encryption_key, encrypter_params)
      end

      def encrypter_params
        {
          count: accessory_to_controller_count
        }
      end

      def encryption_time?
        encryption_key && received_encrypted_request?
      end

      def received_encrypted_request?
        !!cache[:controller_to_accessory_count]
      end

      def encryption_key
        cache[:accessory_to_controller_key]
      end

      def accessory_to_controller_count
        accessory_to_controller_counter.count
      end

      def accessory_to_controller_counter
        cache[:accessory_to_controller_count] ||= Rubyhome::Counter.new
      end

      def accessory_to_controller_count_increment(value)
        accessory_to_controller_counter.increment(value)
      end

      def cache
        Cache.instance
      end
    end
  end
end


