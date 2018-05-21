require 'hkdf'
require 'openssl'
require 'rbnacl/libsodium'
require 'ruby_home-srp'
require_relative '../../hap/hex_pad'
require_relative '../../hap/tlv'
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

      def srp_start_response
        username = 'Pair-Setup'
        password = '031-45-154'

        auth = srp_verifier.generate_userauth(username, password)

        verifier = auth[:verifier]
        salt = auth[:salt]

        challenge_and_proof = srp_verifier.get_challenge_and_proof(username, verifier, salt)
        store_proof(challenge_and_proof[:proof])

        HAP::TLV.encode({
          'kTLVType_Salt' => [challenge_and_proof[:challenge][:salt]].pack('H*'),
          'kTLVType_PublicKey' => [challenge_and_proof[:challenge][:B]].pack('H*'),
          'kTLVType_State' => 2
        })
      end

      def srp_verify_response
        proof = retrieve_proof.dup
        proof[:A] = unpack_request['kTLVType_PublicKey'].unpack1('H*')

        server_m2_proof = srp_verifier.verify_session(proof, unpack_request['kTLVType_Proof'].unpack1('H*'))

        store_session_key(srp_verifier.K)
        forget_proof!

        HAP::TLV.encode({
          'kTLVType_State' => 4,
          'kTLVType_Proof' => [server_m2_proof].pack('H*')
        })
      end

      def exchange_response
        encrypted_data = unpack_request['kTLVType_EncryptedData']

        hkdf = HAP::Crypto::HKDF.new(info: 'Pair-Setup-Encrypt-Info', salt: 'Pair-Setup-Encrypt-Salt')
        key = hkdf.encrypt([session_key].pack('H*'))

        chacha20poly1305ietf = HAP::Crypto::ChaCha20Poly1305.new(key)

        nonce = HAP::HexPad.pad('PS-Msg05')
        decrypted_data = chacha20poly1305ietf.decrypt(nonce, encrypted_data)
        unpacked_decrypted_data = HAP::TLV.read(decrypted_data)

        iosdevicepairingid = unpacked_decrypted_data['kTLVType_Identifier']
        iosdevicesignature = unpacked_decrypted_data['kTLVType_Signature']
        iosdeviceltpk = unpacked_decrypted_data['kTLVType_PublicKey']

        hkdf = HAP::Crypto::HKDF.new(info: 'Pair-Setup-Controller-Sign-Info', salt: 'Pair-Setup-Controller-Sign-Salt')
        iosdevicex = hkdf.encrypt([session_key].pack('H*'))

        iosdeviceinfo = [
          iosdevicex.unpack1('H*'),
          iosdevicepairingid.unpack1('H*'),
          iosdeviceltpk.unpack1('H*')
        ].join
        verify_key = RbNaCl::Signatures::Ed25519::VerifyKey.new(iosdeviceltpk)

        if verify_key.verify(iosdevicesignature, [iosdeviceinfo].pack('H*'))
          hkdf = HAP::Crypto::HKDF.new(info: 'Pair-Setup-Accessory-Sign-Info', salt: 'Pair-Setup-Accessory-Sign-Salt')
          accessory_x = hkdf.encrypt([session_key].pack('H*'))

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

      def store_proof(proof)
        cache[:proof] = proof
      end

      def retrieve_proof
        cache[:proof]
      end

      def forget_proof!
        cache[:proof] = nil
      end

      def store_session_key(key)
        cache[:session_key] = key
      end

      def session_key
        cache[:session_key]
      end
    end
  end
end
