module RubyHome
  module HAP
    class EVResponse
      def initialize(socket, body)
        @socket = socket
        @body = body
        cache[:accessory_to_controller_count] ||= 0
      end

      def send_response
        response = ""

        send_header(response)
        send_body(response)

        encrypted_response = encrypter.encrypt(response).join
        cache[:accessory_to_controller_count] = encrypter.count

        socket << encrypted_response
      end

      private

        STATUS_LINE = ""
        CONTENT_TYPE_LINE = ""
        CONTENT_LENGTH = "application/hap+json \n"
        CRLF = "\x0d\x0a"

        def send_header(socket)
          data = "EVENT/1.0 200 OK#{CRLF}"
          data << "Content-Type: application/hap+json#{CRLF}"
          data << "Content-Length: #{content_length}#{CRLF}"
          data << CRLF

          socket << data
        end

        def send_body(socket)
          socket << body
        end

        def content_length
          body.length
        end

        attr_reader :body, :socket

        def encrypter
          @_encrypter ||= RubyHome::HAP::HTTPEncryption.new(encryption_key, encrypter_params)
        end

        def encrypter_params
          {
            count: cache[:accessory_to_controller_count]
          }
        end

        def encryption_key
          cache[:accessory_to_controller_key]
        end

        def cache
          RubyHome.socket_store[socket]
        end
    end
  end
end
