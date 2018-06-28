require_relative 'application_controller'

module RubyHome
  module HTTP
    class PairVerifiesController < ApplicationController
      post '/pair-verify' do
        content_type 'application/pairing+tlv8'

        case unpack_request['kTLVType_State']
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
        client_public_key = RbNaCl::PublicKey.new(unpack_request['kTLVType_PublicKey'])
        shared_secret = RbNaCl::GroupElement.new(client_public_key).mult(secret_key).to_bytes
        cache[:shared_secret] = shared_secret

        accessoryinfo = [
          public_key.unpack1('H*'),
          accessory_info.device_id.unpack1('H*'),
          client_public_key.to_bytes.unpack1('H*')
        ].join

        signing_key = accessory_info.signing_key
        accessorysignature = signing_key.sign([accessoryinfo].pack('H*'))

        subtlv = HAP::TLV.encode({
          'kTLVType_Identifier' => accessory_info.device_id,
          'kTLVType_Signature' => accessorysignature
        })

        hkdf = HAP::Crypto::HKDF.new(info: 'Pair-Verify-Encrypt-Info', salt: 'Pair-Verify-Encrypt-Salt')
        session_key = hkdf.encrypt(shared_secret)
        cache[:session_key] = session_key

        chacha20poly1305ietf = HAP::Crypto::ChaCha20Poly1305.new(session_key)
        nonce = HAP::HexPad.pad('PV-Msg02')
        encrypted_data = chacha20poly1305ietf.encrypt(nonce, subtlv)

        HAP::TLV.encode({
          'kTLVType_State' => 2,
          'kTLVType_PublicKey' => public_key,
          'kTLVType_EncryptedData' => encrypted_data
        })
      end

      def verify_finish_response
        encrypted_data = unpack_request['kTLVType_EncryptedData']

        chacha20poly1305ietf = HAP::Crypto::ChaCha20Poly1305.new(cache[:session_key])
        nonce = HAP::HexPad.pad('PV-Msg03')
        decrypted_data = chacha20poly1305ietf.decrypt(nonce, encrypted_data)
        unpacked_decrypted_data = HAP::TLV.read(decrypted_data)

        if accessory_info.paired_clients.any? {|h| h[:identifier] == unpacked_decrypted_data['kTLVType_Identifier']}
          hkdf = HAP::Crypto::HKDF.new(info: 'Control-Write-Encryption-Key', salt: 'Control-Salt')
          cache[:controller_to_accessory_key] = hkdf.encrypt(cache[:shared_secret])

          hkdf = HAP::Crypto::HKDF.new(info: 'Control-Read-Encryption-Key', salt: 'Control-Salt')
          cache[:accessory_to_controller_key] = hkdf.encrypt(cache[:shared_secret])

          HAP::TLV.encode({'kTLVType_State' => 4})
        else
          HAP::TLV.encode({'kTLVType_State' => 4, 'kTLVType_Error' => 2})
        end
      end
    end
  end
end
