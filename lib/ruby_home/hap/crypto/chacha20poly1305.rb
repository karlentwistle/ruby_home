module RubyHome
  module HAP
    module Crypto
      class ChaCha20Poly1305
        def initialize(key)
          @key = key
        end

        def encrypt(nonce, message, additional_data = nil)
          chacha20poly1305ietf.encrypt(nonce, message, additional_data)
        end

        def decrypt(nonce, ciphertext, additional_data = nil)
          chacha20poly1305ietf.decrypt(nonce, ciphertext, additional_data)
        end

        private

        attr_reader :key

        def chacha20poly1305ietf
          @_chacha20poly1305ietf ||= RbNaCl::AEAD::ChaCha20Poly1305IETF.new(key)
        end
      end
    end
  end
end
