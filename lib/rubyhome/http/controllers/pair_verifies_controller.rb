require_relative '../../tlv'
require "x25519"

module Rubyhome
  module HTTP
    class PairVerifiesController
      def initialize(request, settings)
        @request = request
        @settings = settings
      end

      def create
        case unpack_request['kTLVType_State']
        when 1
          verify_start_response
        when 3
          verify_finish_response
        end
      end

      private

      attr_reader :request, :settings

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

        salt = "Pair-Verify-Encrypt-Salt"
        sinfo = "Pair-Verify-Encrypt-Info"
        hkdf_opts = { salt: salt, algorithm: 'SHA512', info: sinfo }

        hkdf = HKDF.new(shared_secret, hkdf_opts)
        hkdf.rewind
        session_key = hkdf.next_bytes(32)
        cache[:session_key] = session_key

        chacha20poly1305ietf = RbNaCl::AEAD::ChaCha20Poly1305IETF.new(session_key)
        nonce = ["0000000050562D4D73673032"].pack('H*')
        encrypted_data = chacha20poly1305ietf.encrypt(nonce, subtlv, nil).unpack('H*')[0]

        TLV.pack({
          'kTLVType_State' => 2,
          'kTLVType_PublicKey' => public_key,
          'kTLVType_EncryptedData' => encrypted_data
        })
      end

      def verify_finish_response
        encrypted_data = unpack_request["kTLVType_EncryptedData"]

        chacha20poly1305ietf = RbNaCl::AEAD::ChaCha20Poly1305IETF.new(cache[:session_key])
        nonce = ["0000000050562D4D73673033"].pack('H*')
        decrypted_data = chacha20poly1305ietf.decrypt(nonce, [encrypted_data].pack('H*'), nil)
        unpacked_decrypted_data = TLV.unpack(decrypted_data)

        salt = "Control-Salt"
        sinfo = "Control-Write-Encryption-Key"
        hkdf_opts = { salt: salt, algorithm: 'SHA512', info: sinfo }

        hkdf = HKDF.new(cache[:shared_secret], hkdf_opts)
        hkdf.rewind
        cache[:controller_to_accessory_key] = hkdf.next_bytes(32)

        salt = "Control-Salt"
        sinfo = "Control-Read-Encryption-Key"
        hkdf_opts = { salt: salt, algorithm: 'SHA512', info: sinfo }

        hkdf = HKDF.new(cache[:shared_secret], hkdf_opts)
        hkdf.rewind
        cache[:accessory_to_controller_key] = hkdf.next_bytes(32)

        TLV.pack({
          'kTLVType_State' => 4,
        })
      end

      def unpack_request
        @_unpack_request ||= begin
          request.body.rewind
          TLV.unpack(request.body.read)
        end
      end

      def accessory_info
        settings.accessory_info
      end

      def cache
        Cache.instance
      end
    end
  end
end
