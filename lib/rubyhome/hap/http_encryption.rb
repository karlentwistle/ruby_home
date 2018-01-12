require 'rbnacl/libsodium'

module Rubyhome
  module HAP
    class HTTPEncryption
      def initialize(key, encryption_count: 0)
        @key = key
        @encryption_count = encryption_count
      end

      def encrypt(data)
        data.chars.each_slice(1024).map(&:join).map do |message|
          additional_data = [message.length].pack('v')

          encrypted_data = chacha20poly1305ietf.encrypt(nonce, message, additional_data)
          encryption_count_increment!

          [additional_data, encrypted_data].join
        end
      end

      private

      def encryption_count_increment!
        @encryption_count += 1
      end

      def nonce
        prefix = '00000000'
        num = [@encryption_count].pack('V').unpack('H*').first
        append = '00000000'

        [prefix + num + append].pack('H*')
      end

      def chacha20poly1305ietf
        RbNaCl::AEAD::ChaCha20Poly1305IETF.new(key)
      end

      attr_reader :key
    end
  end
end


