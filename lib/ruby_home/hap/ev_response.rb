module RubyHome
  module HAP
    class EVResponse
      def initialize(session, body)
        @session = session
        @body = body
      end

      def send_response
        send_header(session)
        send_body(session)
      end

      private

      attr_reader :body, :session

      CRLF = -"\x0d\x0a"
      STATUS_LINE = -"EVENT/1.0 200 OK"
      CONTENT_TYPE_LINE = -"Content-Type: application/hap+json"

      def content_length_line
        "Content-Length: #{body.length}"
      end

      def send_header(io)
        data = STATUS_LINE + CRLF
        data << CONTENT_TYPE_LINE + CRLF
        data << content_length_line + CRLF
        data << CRLF

        io.write(data)
      end

      def send_body(io)
        io.write(body)
      end
    end
  end
end
