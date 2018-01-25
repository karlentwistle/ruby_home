module Rubyhome
  module HAP
    module HexPad
      def self.pad(input, pad_length: 24)
        [
          input
            .unpack1('H*')
            .rjust(pad_length, '0')
        ].pack('H*')
      end
    end
  end
end
