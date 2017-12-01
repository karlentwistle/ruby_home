module Rubyhome
  module TLV
    INTEGER_UNPACKER = ->(value) { [value].pack('H*').unpack('C*').first }
    INTEGER_PACKER = ->(value) { [value].pack('C*').unpack('H*').first }

    UTF8_UNPACKER = ->(value) { [value.force_encoding("UTF-8")].pack('H*') }
    UTF8_PACKER = ->(value) { value.force_encoding("UTF-8").bytes.map { |b| b.to_s(16) }.join }

    BYTES_UNPACKER = ->(value) { value }
    BYTES_PACKER = ->(value) { value }

    TLV = Struct.new(:type, :name, :unpack, :pack)
    TLVs = [
      TLV.new("00", 'kTLVType_Method', INTEGER_UNPACKER, INTEGER_PACKER),
      TLV.new("01", 'kTLVType_Identifier', UTF8_UNPACKER, UTF8_PACKER),
      TLV.new("02", 'kTLVType_Salt', BYTES_UNPACKER, BYTES_PACKER),
      TLV.new("03", 'kTLVType_PublicKey', BYTES_UNPACKER, BYTES_PACKER),
      TLV.new("04", 'kTLVType_Proof', BYTES_UNPACKER, BYTES_PACKER),
      TLV.new("05", 'kTLVType_EncryptedData', BYTES_UNPACKER, BYTES_PACKER),
      TLV.new("06", 'kTLVType_State', INTEGER_UNPACKER, INTEGER_PACKER),
      TLV.new("07", 'kTLVType_Error', INTEGER_UNPACKER, INTEGER_PACKER),
      TLV.new("08", 'kTLVType_RetryDelay', INTEGER_UNPACKER, INTEGER_PACKER),
      TLV.new("09", 'kTLVType_Certificate', BYTES_UNPACKER, BYTES_PACKER),
      TLV.new("0a", 'kTLVType_Signature', BYTES_UNPACKER, BYTES_PACKER),
      TLV.new("0b", 'kTLVType_Permissions', INTEGER_UNPACKER, INTEGER_PACKER),
      TLV.new("0c", 'kTLVType_FragmentData', BYTES_UNPACKER, BYTES_PACKER),
      TLV.new("0d", 'kTLVType_FragmentLast', BYTES_UNPACKER, BYTES_PACKER),
    ].freeze

    class << self
      def pack(hash)
        data = ""

        pack_objects(hash).each do |type, value|
          value.chars.each_slice(510).map(&:join).each do |value_slice|
            length = INTEGER_PACKER.call([value_slice].pack('H*').length)

            data << type
            data << length
            data << value_slice
          end
        end

        [data].pack('H*')
      end

      def pack_objects(objects)
        objects.each_with_object({}) do |(unpacked_key, unpacked_value), memo|
          tlv_value = TLVs.find { |tlv| tlv.name == unpacked_key }
          packed_key = tlv_value.type
          packed_value = tlv_value.pack.call(unpacked_value)
          memo[packed_key] = packed_value
        end
      end

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
