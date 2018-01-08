require 'webrick/httpresponse'

module Rubyhome
  module HTTP
    class HAPResponse < WEBrick::HTTPResponse
      def send_response(socket)
        if cache[:accessory_to_controller_key] && !!cache[:accessory_received_encrypted_data]
          response = String.new
          super(response)

          chacha20poly1305ietf = RbNaCl::AEAD::ChaCha20Poly1305IETF.new(cache[:accessory_to_controller_key])
          nonce = ["000000000000000000000000"].pack('H*')
          additional_data = [response.length].pack('v')

          encrypted_response = chacha20poly1305ietf.encrypt(nonce, response, additional_data)

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


