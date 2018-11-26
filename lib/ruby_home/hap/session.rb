module RubyHome
  module HAP
    class Session
      def initialize(socket, encrypter_class: Encrypter)
        @socket = socket
        @controller_to_accessory_count = 0
        @encrypter_class = encrypter_class
      end

      attr_reader :encrypter_class
      attr_reader :socket
      attr_accessor :controller_to_accessory_key
      attr_accessor :accessory_to_controller_key
      attr_writer :controller_to_accessory_count
      attr_accessor :shared_secret
      attr_accessor :session_key
      attr_accessor :srp_session

      def received_encrypted_request?
        controller_to_accessory_count > 0
      end

      def decryption_time?
        controller_to_accessory_key.present?
      end

      def decrypter
        HTTPDecryption.new(controller_to_accessory_key, decrypter_params)
      end

      def sufficient_privileges?
        controller_to_accessory_key? && accessory_to_controller_key?
      end

      def active?
        !socket.closed?
      end

      def write(data)
        if encryption_time?
          socket.write(encrypter.encrypt(data))
        else
          socket.write(data)
        end
      end

      private

        def encrypter
          @_encrypter ||= encrypter_class.new(accessory_to_controller_key)
        end

        def encryption_time?
          accessory_to_controller_key? && received_encrypted_request?
        end

        attr_reader :controller_to_accessory_count

        def accessory_to_controller_key?
          accessory_to_controller_key.present?
        end

        def controller_to_accessory_key?
          controller_to_accessory_key.present?
        end

        def decrypter_params
          { count: controller_to_accessory_count }
        end
    end
  end
end
