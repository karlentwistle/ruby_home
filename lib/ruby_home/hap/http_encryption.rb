require 'rbnacl/libsodium'

module RubyHome
  module HAP
    class HTTPEncryption
      def initialize(key, count: 0)
        @key = key
        @count = count
      end

      def encrypt(data)
        data.chars.each_slice(1024).map(&:join).map do |message|
          additional_data = [message.length].pack('v')

          encrypted_data = chacha20poly1305ietf.encrypt(nonce, message, additional_data)
          increment_count!

          [additional_data, encrypted_data].join
        end
      end

      attr_reader :count

      private

      attr_reader :key

      def increment_count!
        @count += 1
      end

      def nonce
        HexPad.pad([count].pack('Q<'))
      end

      def chacha20poly1305ietf
        RbNaCl::AEAD::ChaCha20Poly1305IETF.new(key)
      end
    end
  end
end


