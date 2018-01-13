require 'webrick/httprequest'
require_relative '../hap/http_decryption'

module Rubyhome
  module HTTP
    class HAPRequest < WEBrick::HTTPRequest
      def parse(socket=nil)
        if cache[:controller_to_accessory_key]
          cache[:accessory_received_encrypted_data] = true

          request_line = socket.read_nonblock(@buffer_size)

          key = cache[:controller_to_accessory_key]
          decrypted_request = Rubyhome::HAP::HTTPDecryption.new(key).decrypt(request_line).join

          super(StringIO.new(decrypted_request))
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
