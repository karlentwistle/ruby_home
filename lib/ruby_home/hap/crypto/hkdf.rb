GEM_HKDF = HKDF

module RubyHome
  module HAP
    module Crypto
      class HKDF
        def initialize(salt:, info:)
          @salt = salt
          @info = info
        end

        def encrypt(source)
          byte_string = convert_string_to_byte_string(source)
          GEM_HKDF.new(byte_string, hkdf_opts).read(BYTE_LENGTH)
        end

        private

        ALGORITHM = "SHA512"
        BYTE_LENGTH = 32

        attr_reader :info, :salt, :source

        def hkdf_opts
          {
            algorithm: ALGORITHM,
            info: info,
            salt: salt
          }
        end

        def convert_string_to_byte_string(string)
          if string.encoding == Encoding::ASCII_8BIT
            string
          else
            [string].pack("H*")
          end
        end
      end
    end
  end
end
