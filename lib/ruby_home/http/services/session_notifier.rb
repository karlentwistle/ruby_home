module RubyHome
  module HTTP
    class SessionNotifier
      def initialize(session, characteristic)
        @session = session
        @characteristic = characteristic
      end

      def after_update(_)
        if session.active?
          send_ev_response
        else
          characteristic.unsubscribe(self)
        end
      end

      def ==(other)
        self.class == other.class &&
          self.session == other.session &&
          self.characteristic == other.characteristic
      end

      attr_reader :session, :characteristic

      private

        def send_ev_response
          HAP::EVResponse.new(session, serialized_characteristic).send_response
        end

        def serialized_characteristic
          HTTP::CharacteristicValueSerializer.new([characteristic]).serialized_json
        end
    end
  end
end
