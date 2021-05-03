module RubyHome
  module HAP
    class Decrypter
      AAD_LENGTH_BYTES = 2
      AUTHENTICATE_TAG_LENGTH_BYTES = 16
      NONCE_32_BIT_FIX_COMMENT_PART = [0].pack("L").freeze

      def initialize(key, count: 0)
        @key = key
        @count = count
      end

      def decrypt(data)
        decrypted_data = []
        read_pointer = 0

        while read_pointer < data.length
          little_endian_length_of_encrypted_data = data[read_pointer...read_pointer + AAD_LENGTH_BYTES]
          length_of_encrypted_data = little_endian_length_of_encrypted_data.unpack1("v")
          read_pointer += AAD_LENGTH_BYTES

          message = data[read_pointer...read_pointer + length_of_encrypted_data]
          read_pointer += length_of_encrypted_data

          auth_tag = data[read_pointer...read_pointer + AUTHENTICATE_TAG_LENGTH_BYTES]
          read_pointer += AUTHENTICATE_TAG_LENGTH_BYTES

          ciphertext = message + auth_tag
          additional_data = little_endian_length_of_encrypted_data
          decrypted_data << chacha20poly1305ietf.decrypt(nonce, ciphertext, additional_data)

          increment_count!
        end

        decrypted_data.join
      end

      attr_reader :count

      private

      attr_reader :key

      def increment_count!
        @count += 1
      end

      def nonce
        NONCE_32_BIT_FIX_COMMENT_PART + [count].pack("Q")
      end

      def chacha20poly1305ietf
        @_chacha20poly1305ietf ||= HAP::Crypto::ChaCha20Poly1305.new(key)
      end
    end
  end
end
