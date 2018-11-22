module RubyHome
  module HAP
    class HAPResponse < WEBrick::HTTPResponse
      def send_response(session)
        socket = session.socket

        if session.encryption_time?
          response = StringIO.new
          super(response)

          encrypter = session.encrypter

          encrypted_response = encrypter.encrypt(response.string).join
          session.accessory_to_controller_count = encrypter.count

          _write_data(socket, encrypted_response)
        else
          super(socket)
        end
      end
    end
  end
end
