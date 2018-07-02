module RubyHome
  module HTTP
    class HAPResponse < WEBrick::HTTPResponse
      def initialize(*args, socket: )
        @_socket = socket
        cache[:accessory_to_controller_count] ||= 0

        super(*args)
      end

      def send_response(socket)
        if encryption_time?
          response = String.new
          super(response)

          encrypted_response = encrypter.encrypt(response).join
          cache[:accessory_to_controller_count] = encrypter.count

          _write_data(socket, encrypted_response)
        else
          super(socket)
        end
      end

      attr_writer :received_encrypted_request

      private

      def encrypter
        @_encrypter ||= RubyHome::HAP::HTTPEncryption.new(encryption_key, encrypter_params)
      end

      def encrypter_params
        {
          count: cache[:accessory_to_controller_count]
        }
      end

      def encryption_time?
        encryption_key && !!@received_encrypted_request
      end

      def encryption_key
        cache[:accessory_to_controller_key]
      end

      def cache
        RequestStore.store[@_socket]
      end
    end
  end
end
