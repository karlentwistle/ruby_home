require_relative 'application_controller'

module RubyHome
  module HTTP
    class PairSetupsController < ApplicationController
      post '/pair-setup' do
        content_type 'application/pairing+tlv8'

        case unpack_request[:state]
        when 1
          start
        when 3
          verify
        when 5
          exchange
        end
      end

      private

      def pairing_failed
        clear_cache

        HAP::TLV.encode({
          :state => 4,
          :error => 2
        })
      end

      def start
        start_srp = StartSRPService.new(
          username: accessory_info.username,
          password: accessory_info.password
        )

        cache[:srp_session] = start_srp.proof

        HAP::TLV.encode({
          :salt => start_srp.salt_bytes,
          :public_key => start_srp.public_key_bytes,
          :state => 2
        })
      end

      def verify
        verify_srp = VerifySRPService.new(
          device_proof: unpack_request[:proof],
          srp_session: cache[:srp_session],
          public_key: unpack_request[:public_key],
        )

        if verify_srp.valid?
          cache[:session_key] = verify_srp.session_key
          cache[:srp_session] = nil

          HAP::TLV.encode({
            :state => 4,
            :proof => verify_srp.server_proof
          })
        else
          pairing_failed
        end
      end

      def exchange
        encrypted_data = unpack_request[:encrypted_data]

        hkdf = HAP::Crypto::HKDF.new(info: 'Pair-Setup-Encrypt-Info', salt: 'Pair-Setup-Encrypt-Salt')
        key = hkdf.encrypt(cache[:session_key])

        chacha20poly1305ietf = HAP::Crypto::ChaCha20Poly1305.new(key)

        nonce = HexHelper.pad('PS-Msg05')
        decrypted_data = chacha20poly1305ietf.decrypt(nonce, encrypted_data)
        unpacked_decrypted_data = HAP::TLV.read(decrypted_data)

        iosdevicepairingid = unpacked_decrypted_data[:identifier]
        iosdevicesignature = unpacked_decrypted_data['kTLVType_Signature']
        iosdeviceltpk = unpacked_decrypted_data[:public_key]

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
            :identifier => accessory_info.device_id,
            :public_key => accessoryltpk,
            'kTLVType_Signature' => accessorysignature
          })

          nonce = HexHelper.pad('PS-Msg06')
          encrypted_data = chacha20poly1305ietf.encrypt(nonce, subtlv)

          pairing_params = { admin: true, identifier: iosdevicepairingid, public_key: iosdeviceltpk.unpack1('H*') }
          accessory_info.add_paired_client pairing_params

          HAP::TLV.encode({
            :state => 6,
            :encrypted_data => encrypted_data
          })
        end
      end
    end
  end
end
