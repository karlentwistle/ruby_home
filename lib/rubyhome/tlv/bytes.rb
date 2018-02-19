module Rubyhome
  module TLV
    module Bytes
      extend self

      def pack(input)
        if input.length.odd?
          input.insert(0, '0')
        else
          input
        end
      end

      def unpack(input)
        input
      end
    end
  end
end
