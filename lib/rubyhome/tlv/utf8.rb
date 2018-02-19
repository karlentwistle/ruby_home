module Rubyhome
  module TLV
    module Utf8
      extend self

      def pack(input)
        input.bytes.map { |b| b.to_s(16) }.join
      end

      def unpack(input)
        [input]
          .pack('H*')
          .force_encoding('utf-8')
          .encode('utf-8')
      end
    end
  end
end
