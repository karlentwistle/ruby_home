require 'webrick/httprequest'

module Rubyhome
  module HTTP
    class HAPRequest < WEBrick::HTTPRequest
      MAX_FRAME_SIZE = 1024

      def parse(socket=nil)
        if cache[:controller_to_accessory_key]
          cache[:accessory_received_encrypted_data] = true

          request_line = socket.read_nonblock(MAX_FRAME_SIZE)

          chacha20poly1305ietf = RbNaCl::AEAD::ChaCha20Poly1305IETF.new(cache[:controller_to_accessory_key])
          nonce = ["000000000000000000000000"].pack('H*')

          unpacked_request_line = request_line.unpack('H*')[0]
          message = [unpacked_request_line[4..-1]].pack('H*')
          additional_data = [unpacked_request_line[0...4]].pack('H*')

          decrypted_request_line = chacha20poly1305ietf.decrypt(nonce, message, additional_data)

          super(StringIO.new(decrypted_request_line))
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
