require_relative 'application_controller'

module RubyHome
  module HTTP
    class PairVerifiesController < ApplicationController
      post '/' do
        content_type 'application/pairing+tlv8'

        verify_accessory_paired

        case unpack_request[:state]
        when 1
          verify_start_response
        when 3
          verify_finish_response
        end
      end

      private

      def verify_start_response
        secret_key = RbNaCl::PrivateKey.generate
        public_key = secret_key.public_key.to_bytes
        client_public_key = RbNaCl::PublicKey.new(unpack_request[:public_key])
        shared_secret = RbNaCl::GroupElement.new(client_public_key).mult(secret_key).to_bytes
        session.shared_secret = shared_secret

        accessoryinfo = [
          public_key.unpack1('H*'),
          accessory_info.device_id.unpack1('H*'),
          client_public_key.to_bytes.unpack1('H*')
        ].join

        signing_key = accessory_info.signing_key
        accessorysignature = signing_key.sign([accessoryinfo].pack('H*'))

        subtlv = tlv(identifier: accessory_info.device_id, signature: accessorysignature)

        hkdf = HAP::Crypto::HKDF.new(info: 'Pair-Verify-Encrypt-Info', salt: 'Pair-Verify-Encrypt-Salt')
        session_key = hkdf.encrypt(shared_secret)
        session.session_key = session_key

        chacha20poly1305ietf = HAP::Crypto::ChaCha20Poly1305.new(session_key)
        nonce = HexHelper.pad('PV-Msg02')
        encrypted_data = chacha20poly1305ietf.encrypt(nonce, subtlv)

        tlv state: 2, public_key: public_key, encrypted_data: encrypted_data
      end

      def verify_finish_response
        encrypted_data = unpack_request[:encrypted_data]

        chacha20poly1305ietf = HAP::Crypto::ChaCha20Poly1305.new(session.session_key)
        nonce = HexHelper.pad('PV-Msg03')
        decrypted_data = chacha20poly1305ietf.decrypt(nonce, encrypted_data)
        unpacked_decrypted_data = TLV.decode(decrypted_data)

        if accessory_info.paired_clients.any? {|h| h[:identifier] == unpacked_decrypted_data[:identifier]}
          shared_secret = HAP::Crypto::SessionKey.new(session.shared_secret)

          session.controller_to_accessory_key = shared_secret.controller_to_accessory_key
          session.accessory_to_controller_key = shared_secret.accessory_to_controller_key

          session.session_key = nil
          session.shared_secret = nil

          tlv state: 4
        else
          tlv state: 4, error: 2
        end
      end

      def verify_accessory_paired
        halt 403 unless accessory_info.paired?
      end
    end
  end
end
