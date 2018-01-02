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
        puts unpack_request
        case unpack_request['kTLVType_State']
        when 1
          verify_start_response
        end
      end

      private

      attr_reader :request, :settings

      def verify_start_response
        secret_key = X25519::Scalar.generate
        public_key = secret_key.public_key.to_bytes.unpack('H*')[0]
        client_public_key = X25519::MontgomeryU.new([unpack_request['kTLVType_PublicKey']].pack('H*'))
        shared_secret = secret_key.multiply(client_public_key).to_bytes

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

        chacha20poly1305ietf = RbNaCl::AEAD::ChaCha20Poly1305IETF.new(session_key)
        nonce = ["0000000050562D4D73673032"].pack('H*')
        encrypted_data = chacha20poly1305ietf.encrypt(nonce, subtlv, nil).unpack('H*')[0]

        TLV.pack({
          'kTLVType_State' => 2,
          'kTLVType_PublicKey' => public_key,
          'kTLVType_EncryptedData' => encrypted_data
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
    end
  end
end

