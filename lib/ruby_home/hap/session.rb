module RubyHome
  module HAP
    class Session
      def initialize(socket)
        @socket = socket
        @accessory_to_controller_count = 0
        @controller_to_accessory_count = 0
      end

      attr_reader :socket
      attr_accessor :controller_to_accessory_key
      attr_accessor :accessory_to_controller_key
      attr_writer :accessory_to_controller_count
      attr_writer :controller_to_accessory_count
      attr_accessor :shared_secret
      attr_accessor :session_key
      attr_accessor :srp_session

      def encryption_time?
        accessory_to_controller_key? && received_encrypted_request?
      end

      def received_encrypted_request?
        controller_to_accessory_count > 0
      end

      def encrypter
        HTTPEncryption.new(accessory_to_controller_key, encrypter_params)
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

      private

        attr_reader :accessory_to_controller_count,
                    :controller_to_accessory_count

        def accessory_to_controller_key?
          accessory_to_controller_key.present?
        end

        def controller_to_accessory_key?
          controller_to_accessory_key.present?
        end

        def encrypter_params
          { count: accessory_to_controller_count }
        end

        def decrypter_params
          { count: controller_to_accessory_count }
        end
    end
  end
end
