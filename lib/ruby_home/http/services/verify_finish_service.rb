module RubyHome
  class VerifyFinishService
    def initialize(accessory_info: , encrypted_data: , session_key:, shared_secret:)
      @accessory_info = accessory_info
      @encrypted_data = encrypted_data
      @session_key = session_key
      @shared_secret = HAP::Crypto::SessionKey.new(shared_secret)
    end

    def run
      if paired_client_exists?
        RubyHome.dns_service.update

        OpenStruct.new(
          success?: true,
          controller_to_accessory_key: shared_secret.controller_to_accessory_key,
          accessory_to_controller_key: shared_secret.accessory_to_controller_key
        )
      else
        OpenStruct.new(success?: false)
      end
    end

    private

      NONCE = -'PV-Msg03'

      attr_reader :accessory_info, :encrypted_data, :session_key, :shared_secret

      def paired_client_exists?
        accessory_info.paired_clients.any? do |paired_client|
          paired_client[:identifier] == identifier
        end
      end

      def chacha20poly1305
        HAP::Crypto::ChaCha20Poly1305.new(session_key)
      end

      def nonce
        HexHelper.pad(NONCE)
      end

      def decrypted_data
        chacha20poly1305.decrypt(nonce, encrypted_data)
      end

      def unpacked_decrypted_data
        TLV.decode(decrypted_data)
      end

      def identifier
        unpacked_decrypted_data[:identifier]
      end
  end
end
