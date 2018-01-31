require_relative '../../srp'
require_relative '../../tlv'
require_relative '../../hap/hex_pad'
require 'hkdf'
require 'openssl'
require 'rbnacl/libsodium'

module Rubyhome
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

        TLV.pack({
          'kTLVType_Salt' => challenge_and_proof[:challenge][:salt],
          'kTLVType_PublicKey' => challenge_and_proof[:challenge][:B],
          'kTLVType_State' => 2
        })
      end

      def srp_verify_response
        proof = retrieve_proof.dup
        proof[:A] = unpack_request['kTLVType_PublicKey']

        client_m1_proof = unpack_request['kTLVType_Proof']
        server_m2_proof = srp_verifier.verify_session(proof, unpack_request['kTLVType_Proof'])

        store_session_key(srp_verifier.K)
        forget_proof!

        TLV.pack({
          'kTLVType_State' => 4,
          'kTLVType_Proof' => server_m2_proof
        })
      end

      def exchange_response
        encrypted_data = unpack_request['kTLVType_EncryptedData']

        hkdf = HAP::HKDFEncryption.new(info: "Pair-Setup-Encrypt-Info", salt: "Pair-Setup-Encrypt-Salt")
        key = hkdf.encrypt([session_key].pack('H*'))

        chacha20poly1305ietf = RbNaCl::AEAD::ChaCha20Poly1305IETF.new(key)

        nonce = HAP::HexPad.pad("PS-Msg05")
        decrypted_data = chacha20poly1305ietf.decrypt(nonce, [encrypted_data].pack('H*'), nil)
        unpacked_decrypted_data = TLV.unpack(decrypted_data)

        iosdevicepairingid = unpacked_decrypted_data['kTLVType_Identifier']
        iosdevicesignature = unpacked_decrypted_data['kTLVType_Signature']
        iosdeviceltpk = unpacked_decrypted_data['kTLVType_PublicKey']

        hkdf = HAP::HKDFEncryption.new(info: "Pair-Setup-Controller-Sign-Info", salt: "Pair-Setup-Controller-Sign-Salt")
        iosdevicex = hkdf.encrypt([session_key].pack('H*'))

        iosdeviceinfo = [
          iosdevicex.unpack('H*'),
          TLV::UTF8_PACKER.call(iosdevicepairingid),
          iosdeviceltpk
        ].join
        verify_key = RbNaCl::Signatures::Ed25519::VerifyKey.new([iosdeviceltpk].pack('H*'))

        if verify_key.verify([iosdevicesignature].pack('H*'), [iosdeviceinfo].pack('H*'))
          hkdf = HAP::HKDFEncryption.new(info: "Pair-Setup-Accessory-Sign-Info", salt: "Pair-Setup-Accessory-Sign-Salt")
          accessory_x = hkdf.encrypt([session_key].pack('H*'))

          signing_key = accessory_info.signing_key
          accessoryltpk = signing_key.verify_key.to_bytes.unpack('H*')[0]
          accessoryinfo = [
            accessory_x.unpack('H*'),
            TLV::UTF8_PACKER.call(accessory_info.device_id),
            accessoryltpk
          ].join

          accessorysignature = signing_key.sign([accessoryinfo].pack('H*')).unpack('H*')[0]

          subtlv = TLV.pack({
            'kTLVType_Identifier' => accessory_info.device_id,
            'kTLVType_PublicKey' => accessoryltpk,
            'kTLVType_Signature' => accessorysignature
          })

          nonce = HAP::HexPad.pad("PS-Msg06")
          encrypted_data = chacha20poly1305ietf.encrypt(nonce, subtlv, nil).unpack('H*')[0]

          pairing_params = {
            admin: true,
            identifier: iosdevicepairingid,
            public_key: iosdeviceltpk
          }
          Pairing.create!(pairing_params)

          TLV.pack({
            'kTLVType_State' => 6,
            'kTLVType_EncryptedData' => encrypted_data
          })
        end
      end

      def srp_verifier
        @_verifier ||= Rubyhome::SRP::Verifier.new
      end

      def store_proof(proof)
        Cache.instance[:proof] = proof
      end

      def retrieve_proof
        Cache.instance[:proof]
      end

      def forget_proof!
        Cache.instance[:proof] = nil
      end

      def store_session_key(key)
        Cache.instance[:session_key] = key
      end

      def session_key
        Cache.instance[:session_key]
      end
    end
  end
end
