module RubyHome
  module HAP
    class Session
      PARSE_BUFFER_SIZE = 65536

      def initialize(socket, decrypter_class: Decrypter, encrypter_class: Encrypter)
        @socket = socket
        @encrypter_class = encrypter_class
        @decrypter_class = decrypter_class
      end

      attr_accessor(
        :controller_to_accessory_key,
        :accessory_to_controller_key,
        :shared_secret,
        :session_key,
        :srp_session
      )

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

      alias_method :<<, :write

      def parse
        if decryption_time?
          received_encrypted_request!
          StringIO.new(
            decrypter.decrypt(
              socket.read_nonblock(PARSE_BUFFER_SIZE)
            )
          )
        else
          socket
        end
      end

      def received_encrypted_request!
        @received_encrypted_request ||= true
      end

      private

        attr_reader :socket, :encrypter_class, :decrypter_class

        def received_encrypted_request?
          @received_encrypted_request ||= false
        end

        def encrypter
          @_encrypter ||= encrypter_class.new(accessory_to_controller_key)
        end

        def encryption_time?
          accessory_to_controller_key? && received_encrypted_request?
        end

        def decrypter
          @_decrypter ||= decrypter_class.new(controller_to_accessory_key)
        end

        def decryption_time?
          !!controller_to_accessory_key
        end

        def accessory_to_controller_key?
          !!accessory_to_controller_key
        end

        def controller_to_accessory_key?
          !!controller_to_accessory_key
        end
    end
  end
end
