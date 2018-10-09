module RubyHome
  module HTTP
    class SocketNotifier
      def initialize(socket)
        @socket = socket
      end

      def updated(characteristic)
        HAP::EVResponse.new(socket, serialized_characteristic(characteristic)).send_response
      end

      private

        def serialized_characteristic(characteristic)
          HTTP::CharacteristicValueSerializer.new([characteristic]).serialized_json
        end

        attr_reader :socket
    end
  end
end
