module RubyHome
  module HTTP
    class HAPRequest < WEBrick::HTTPRequest
      def initialize(*args, socket: )
        @_socket = socket
        cache[:controller_to_accessory_count] ||= 0

        super(*args)
      end

      def parse(socket=nil)
        if decryption_time?
          request_line = socket.read_nonblock(@buffer_size)

          decrypted_request = decrypter.decrypt(request_line).join
          cache[:controller_to_accessory_count] = decrypter.count

          super(StringIO.new(decrypted_request))
        else
          super(socket)
        end
      end

      def received_encrypted_request?
        cache[:controller_to_accessory_count] >= 1
      end

      def meta_vars
        super.tap do |meta|
          meta["REQUEST_SOCKET"] = @_socket
        end
      end

      private

      def decrypter
        @_decrypter ||= RubyHome::HAP::HTTPDecryption.new(decryption_key, decrypter_params)
      end

      def decrypter_params
        {
          count: cache[:controller_to_accessory_count]
        }
      end

      def decryption_time?
        !!decryption_key
      end

      def decryption_key
        cache[:controller_to_accessory_key]
      end

      def cache
        RequestStore.store[@_socket]
      end
    end
  end
end
