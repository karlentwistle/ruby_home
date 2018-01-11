require 'webrick/httpresponse'
require_relative '../hap/http_encryption'

module Rubyhome
  module HTTP
    class HAPResponse < WEBrick::HTTPResponse
      def send_response(socket)
        if cache[:accessory_to_controller_key] && !!cache[:accessory_received_encrypted_data]
          response = String.new
          super(response)

          key = cache[:accessory_to_controller_key]

          encrypted_response = [Rubyhome::HAP::HTTPEncryption.new(key).pack(response).join].pack('H*')

          _write_data(socket, encrypted_response)
        else
          super(socket)
        end
      end

      private

      def cache
        Cache.instance
      end
    end
  end
end


