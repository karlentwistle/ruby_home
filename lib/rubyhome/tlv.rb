module Rubyhome
  module TLV
    INTEGER_UNPACKER = ->(value) { [value].pack('H*').unpack('C*').first }
    UTF8_UNPACKER = ->(value) { [value.force_encoding("UTF-8")].pack('H*') }
    BYTES_UNPACKER = ->(value) { value }
    TLV = Struct.new(:type, :name, :unpack)
    TLVs = [
      TLV.new("00", 'kTLVType_Method', INTEGER_UNPACKER),
      TLV.new("01", 'kTLVType_Identifier', UTF8_UNPACKER),
      TLV.new("02", 'kTLVType_Salt', BYTES_UNPACKER),
      TLV.new("03", 'kTLVType_PublicKey', BYTES_UNPACKER),
      TLV.new("04", 'kTLVType_Proof', BYTES_UNPACKER),
      TLV.new("05", 'kTLVType_EncryptedData', BYTES_UNPACKER),
      TLV.new("06", 'kTLVType_State', INTEGER_UNPACKER),
      TLV.new("07", 'kTLVType_Error', INTEGER_UNPACKER),
      TLV.new("08", 'kTLVType_RetryDelay', INTEGER_UNPACKER),
      TLV.new("09", 'kTLVType_Certificate', BYTES_UNPACKER),
      TLV.new("0a", 'kTLVType_Signature', BYTES_UNPACKER),
      TLV.new("0b", 'kTLVType_Permissions', INTEGER_UNPACKER),
      TLV.new("0c", 'kTLVType_FragmentData', BYTES_UNPACKER),
      TLV.new("0d", 'kTLVType_FragmentLast', BYTES_UNPACKER),
    ].freeze

    class << self
      def unpack(input)
        data = input.unpack('H*')[0]
        objects = {}
        scanner_index = 0

        while scanner_index < data.length do
          type = data[scanner_index, 2]
          scanner_index += 2

          byte_length = INTEGER_UNPACKER.call(data[scanner_index, 2]) * 2
          scanner_index += 2

          newData = data[scanner_index, byte_length]
          if objects[type]
            objects[type] << newData
          else
            objects[type] = newData
          end
          scanner_index += byte_length
        end

        unpack_objects(objects)
      end

      def unpack_objects(objects)
        objects.each_with_object({}) do |(packed_key, packed_value), memo|
          tlv_value = TLVs.find { |tlv| tlv.type == packed_key }
          unpacked_key = tlv_value.name
          unpacked_value = tlv_value.unpack.call(packed_value)
          memo[unpacked_key] = unpacked_value
        end
      end
    end
  end
end
