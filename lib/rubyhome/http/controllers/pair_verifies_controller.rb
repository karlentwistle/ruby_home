require_relative '../../tlv'
require_relative '../../hap/hkdf_encryption'
require_relative '../../hap/hex_pad'
require 'x25519'

module Rubyhome
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
        secret_key = X25519::Scalar.generate
        public_key = secret_key.public_key.to_bytes.unpack('H*')[0]
        client_public_key = X25519::MontgomeryU.new([unpack_request['kTLVType_PublicKey']].pack('H*'))
        shared_secret = secret_key.multiply(client_public_key).to_bytes
        cache[:shared_secret] = shared_secret

        accessoryinfo = [
          public_key,
          TLV::UTF8_PACKER.call(accessory_info.device_id),
          client_public_key.to_bytes.unpack('H*')[0]
        ].join

        signing_key = accessory_info.signing_key
        accessorysignature = signing_key.sign([accessoryinfo].pack('H*')).unpack('H*')[0]

        subtlv = TLV.pack({
          'kTLVType_Identifier' => accessory_info.device_id,
          'kTLVType_Signature' => accessorysignature
        })

        hkdf = HAP::HKDFEncryption.new(info: 'Pair-Verify-Encrypt-Info', salt: 'Pair-Verify-Encrypt-Salt')
        session_key = hkdf.encrypt(shared_secret)
        cache[:session_key] = session_key

        chacha20poly1305ietf = RbNaCl::AEAD::ChaCha20Poly1305IETF.new(session_key)
        nonce = HAP::HexPad.pad('PV-Msg02')
        encrypted_data = chacha20poly1305ietf.encrypt(nonce, subtlv, nil).unpack('H*')[0]

        TLV.pack({
          'kTLVType_State' => 2,
          'kTLVType_PublicKey' => public_key,
          'kTLVType_EncryptedData' => encrypted_data
        })
      end

      def verify_finish_response
        encrypted_data = unpack_request['kTLVType_EncryptedData']

        chacha20poly1305ietf = RbNaCl::AEAD::ChaCha20Poly1305IETF.new(cache[:session_key])
        nonce = HAP::HexPad.pad('PV-Msg03')
        decrypted_data = chacha20poly1305ietf.decrypt(nonce, [encrypted_data].pack('H*'), nil)
        unpacked_decrypted_data = TLV.unpack(decrypted_data)

        if Pairing.exists?(identifier: unpacked_decrypted_data['kTLVType_Identifier'])
          hkdf = HAP::HKDFEncryption.new(info: 'Control-Write-Encryption-Key', salt: 'Control-Salt')
          cache[:controller_to_accessory_key] = hkdf.encrypt(cache[:shared_secret])

          hkdf = HAP::HKDFEncryption.new(info: 'Control-Read-Encryption-Key', salt: 'Control-Salt')
          cache[:accessory_to_controller_key] = hkdf.encrypt(cache[:shared_secret])

          TLV.pack({'kTLVType_State' => 4})
        else
          TLV.pack({'kTLVType_State' => 4, 'kTLVType_Error' => 2})
        end
      end
    end
  end
end
