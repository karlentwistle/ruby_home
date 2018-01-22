module Rubyhome
  module HAP
    module HexPad
      def self.pad(input, pad_length: 12)
        [
          input
            .unpack1('H*')
            .rjust(24, '0')
        ].pack('H*')
      end
    end
  end
end
