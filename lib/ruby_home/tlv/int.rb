module RubyHome
  module TLV
    module Int
      extend self

      def pack(input)
        [input].pack('C*').unpack1('H*')
      end

      def unpack(input)
        [input].pack('H*').unpack1('C*')
      end
    end
  end
end
