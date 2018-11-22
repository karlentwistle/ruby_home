module RubyHome
  module HAP
    class EVResponse
      def initialize(session, body)
        @session = session
        @socket = session.socket
        @body = body
      end

      def send_response
        response = ''

        send_header(response)
        send_body(response)

        encrypter = session.encrypter
        encrypted_response = encrypter.encrypt(response).join
        session.accessory_to_controller_count = encrypter.count

        socket << encrypted_response
      end

      private

        attr_reader :body, :socket, :session

        CRLF = -"\x0d\x0a"
        STATUS_LINE = -'EVENT/1.0 200 OK'
        CONTENT_TYPE_LINE = -'Content-Type: application/hap+json'

        def send_header(socket)
          socket << STATUS_LINE + CRLF
          socket << CONTENT_TYPE_LINE + CRLF
          socket << content_length_line + CRLF
          socket << CRLF
        end

        def send_body(socket)
          socket << body
        end

        def content_length_line
          "Content-Length: #{body.length}"
        end
    end
  end
end
