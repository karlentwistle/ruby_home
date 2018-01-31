require 'webrick/httpresponse'
require_relative '../hap/http_encryption'

module Rubyhome
  module HTTP
    class HAPResponse < WEBrick::HTTPResponse
      def initialize(*args)
        @_accessory_to_controller_count = 0

        super
      end

      def send_response(socket)
        if encryption_time?
          response = String.new
          super(response)

          encrypted_response = encrypter.encrypt(response).join
          @_accessory_to_controller_count += encrypter.count

          _write_data(socket, encrypted_response)
        else
          super(socket)
        end
      end

      attr_writer :received_encrypted_request

      private

      def encrypter
        @_encrypter ||= Rubyhome::HAP::HTTPEncryption.new(encryption_key, encrypter_params)
      end

      def encrypter_params
        {
          count: @_accessory_to_controller_count
        }
      end

      def encryption_time?
        encryption_key && !!@received_encrypted_request
      end

      def encryption_key
        cache[:accessory_to_controller_key]
      end

      def cache
        Cache.instance
      end
    end
  end
end


