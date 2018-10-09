module RubyHome
  module HTTP
    class SocketNotifier
      def initialize(socket, characteristic)
        @socket = socket
        @characteristic = characteristic
      end

      def updated(_)
        if socket_still_active?
          send_ev_response
        else
          characteristic.unsubscribe(self)
        end
      end

      def ==(other_object)
        self.socket == other_object.socket && self.characteristic == other_object.characteristic
      end

      attr_reader :socket, :characteristic

      private

        def socket_still_active?
          RubyHome.socket_store.include?(socket)
        end

        def send_ev_response
          HAP::EVResponse.new(socket, serialized_characteristic).send_response
        end

        def serialized_characteristic
          HTTP::CharacteristicValueSerializer.new([characteristic]).serialized_json
        end
    end
  end
end
