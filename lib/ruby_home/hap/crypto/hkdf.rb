require 'rbnacl/libsodium'

GEM_HKDF = HKDF

module RubyHome
  module HAP
    module Crypto
      class HKDF
        def initialize(salt:, info: )
          @salt = salt
          @info = info
        end

        def encrypt(source)
          byte_string = convert_string_to_byte_string(source)
          GEM_HKDF.new(byte_string, hkdf_opts).next_bytes(BYTE_LENGTH)
        end

        private

        BYTE_LENGTH = 32

        attr_reader :info, :salt, :source

        def hkdf_opts
          {
            algorithm: algorithm,
            info: info,
            salt: salt
          }
        end

        def algorithm
          'SHA512'
        end

        def convert_string_to_byte_string(string)
          if string.encoding == Encoding::ASCII_8BIT
            string
          else
            [string].pack('H*')
          end
        end
      end
    end
  end
end
