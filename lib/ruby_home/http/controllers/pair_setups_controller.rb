require_relative 'application_controller'

module RubyHome
  module HTTP
    class PairSetupsController < ApplicationController
      post '/pair-setup' do
        content_type 'application/pairing+tlv8'

        case unpack_request['kTLVType_State']
        when 1
          srp_start_response
        when 3
          srp_verify_response
        when 5
          exchange_response
        end
      end

      private

      def pairing_failed_response
        clear_cache

        HAP::TLV.encode({
          'kTLVType_State' => 4,
          'kTLVType_Error' => 2
        })
      end

      def srp_start_response
        start_srp = StartSRPService.new(username: AccessoryInfo.username, password: AccessoryInfo.password)

        cache[:proof] = start_srp.proof

        HAP::TLV.encode({
          'kTLVType_Salt' => start_srp.salt_bytes,
          'kTLVType_PublicKey' => start_srp.public_key_bytes,
          'kTLVType_State' => 2
        })
      end

      def srp_verify_response
        proof = cache[:proof].dup
        public_key = unpack_request['kTLVType_PublicKey']
        return pairing_failed_response unless public_key

        proof[:A] = public_key.unpack1('H*')

        server_m2_proof = srp_verifier.verify_session(proof, unpack_request['kTLVType_Proof'].unpack1('H*'))
        return pairing_failed_response unless server_m2_proof

        cache[:session_key] = srp_verifier.K
        cache[:proof] = nil

        HAP::TLV.encode({
          'kTLVType_State' => 4,
          'kTLVType_Proof' => [server_m2_proof].pack('H*')
        })
      end

      def exchange_response
        encrypted_data = unpack_request['kTLVType_EncryptedData']

        hkdf = HAP::Crypto::HKDF.new(info: 'Pair-Setup-Encrypt-Info', salt: 'Pair-Setup-Encrypt-Salt')
        key = hkdf.encrypt(cache[:session_key])

        chacha20poly1305ietf = HAP::Crypto::ChaCha20Poly1305.new(key)

        nonce = HAP::HexPad.pad('PS-Msg05')
        decrypted_data = chacha20poly1305ietf.decrypt(nonce, encrypted_data)
        unpacked_decrypted_data = HAP::TLV.read(decrypted_data)

        iosdevicepairingid = unpacked_decrypted_data['kTLVType_Identifier']
        iosdevicesignature = unpacked_decrypted_data['kTLVType_Signature']
        iosdeviceltpk = unpacked_decrypted_data['kTLVType_PublicKey']

        hkdf = HAP::Crypto::HKDF.new(info: 'Pair-Setup-Controller-Sign-Info', salt: 'Pair-Setup-Controller-Sign-Salt')
        iosdevicex = hkdf.encrypt(cache[:session_key])

        iosdeviceinfo = [
          iosdevicex.unpack1('H*'),
          iosdevicepairingid.unpack1('H*'),
          iosdeviceltpk.unpack1('H*')
        ].join
        verify_key = RbNaCl::Signatures::Ed25519::VerifyKey.new(iosdeviceltpk)

        if verify_key.verify(iosdevicesignature, [iosdeviceinfo].pack('H*'))
          hkdf = HAP::Crypto::HKDF.new(info: 'Pair-Setup-Accessory-Sign-Info', salt: 'Pair-Setup-Accessory-Sign-Salt')
          accessory_x = hkdf.encrypt(cache[:session_key])

          signing_key = accessory_info.signing_key
          accessoryltpk = signing_key.verify_key.to_bytes
          accessoryinfo = [
            accessory_x.unpack1('H*'),
            accessory_info.device_id.unpack1('H*'),
            accessoryltpk.unpack1('H*')
          ].join

          accessorysignature = signing_key.sign([accessoryinfo].pack('H*'))

          subtlv = HAP::TLV.encode({
            'kTLVType_Identifier' => accessory_info.device_id,
            'kTLVType_PublicKey' => accessoryltpk,
            'kTLVType_Signature' => accessorysignature
          })

          nonce = HAP::HexPad.pad('PS-Msg06')
          encrypted_data = chacha20poly1305ietf.encrypt(nonce, subtlv)

          pairing_params = { admin: true, identifier: iosdevicepairingid, public_key: iosdeviceltpk.unpack1('H*') }
          accessory_info.add_paired_client pairing_params

          HAP::TLV.encode({
            'kTLVType_State' => 6,
            'kTLVType_EncryptedData' => encrypted_data
          })
        end
      end

      def srp_verifier
        @_verifier ||= RubyHome::SRP::Verifier.new
      end
    end
  end
end
