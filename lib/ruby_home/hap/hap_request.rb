module RubyHome
  module HAP
    class HAPRequest < WEBrick::HTTPRequest
      def parse(session)
        @session = session
        socket = session.socket

        if session.decryption_time?
          request_line = socket.read_nonblock(@buffer_size)

          decrypter = session.decrypter
          decrypted_request = decrypter.decrypt(request_line).join
          session.controller_to_accessory_count = decrypter.count

          super(StringIO.new(decrypted_request))
        else
          super(socket)
        end
      end

      def meta_vars
        super.merge(
          { "REQUEST_SESSION" => @session }
        )
      end
    end
  end
end
