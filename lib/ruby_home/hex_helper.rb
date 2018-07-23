module RubyHome
  module HexHelper
    def self.pad(input, pad_length: 24)
      pack_hex_string(unpack_hex_string(input).rjust(pad_length, '0'))
    end

    def self.unpack_hex_string(input)
      input.to_s.unpack1('H*')
    end

    def self.pack_hex_string(input)
      [input].pack('H*')
    end
  end
end
