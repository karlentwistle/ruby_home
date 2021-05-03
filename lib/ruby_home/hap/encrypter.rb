module RubyHome
  module HAP
    class Session
      class Encrypter
        MAX_FRAME_LENGTH = 1024
        NONCE_32_BIT_FIX_COMMENT_PART = [0].pack("L").freeze

        def initialize(key, count: 0)
          @key = key
          @count = count
        end

        def encrypt(data)
          encrypted_data = []
          read_pointer = 0

          while read_pointer < data.length
            encrypted_frame = ""

            frame = data[read_pointer...read_pointer + MAX_FRAME_LENGTH]
            length_of_encrypted_data = frame.length
            little_endian_length_of_encrypted_data = [length_of_encrypted_data].pack("v")

            encrypted_frame += little_endian_length_of_encrypted_data
            encrypted_frame += chacha20poly1305ietf.encrypt(nonce, frame, little_endian_length_of_encrypted_data)
            encrypted_data << encrypted_frame

            read_pointer += length_of_encrypted_data
            increment_count!
          end

          encrypted_data.join
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
end
