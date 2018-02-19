Dir[File.dirname(__FILE__) + '/tlv/*.rb'].each {|file| require file }

module Rubyhome
  module TLV
    extend self

    TLV = Struct.new(:type, :name, :handler)
    TLVs = [
      TLV.new('00', 'kTLVType_Method', Int),
      TLV.new('01', 'kTLVType_Identifier', Utf8),
      TLV.new('02', 'kTLVType_Salt', Bytes),
      TLV.new('03', 'kTLVType_PublicKey', Bytes),
      TLV.new('04', 'kTLVType_Proof', Bytes),
      TLV.new('05', 'kTLVType_EncryptedData', Bytes),
      TLV.new('06', 'kTLVType_State', Int),
      TLV.new('07', 'kTLVType_Error', Int),
      TLV.new('08', 'kTLVType_RetryDelay', Int),
      TLV.new('09', 'kTLVType_Certificate', Bytes),
      TLV.new('0a', 'kTLVType_Signature', Bytes),
      TLV.new('0b', 'kTLVType_Permissions', Int),
      TLV.new('0c', 'kTLVType_FragmentData', Bytes),
      TLV.new('0d', 'kTLVType_FragmentLast', Bytes),
    ].freeze

    def pack(hash)
      data = ''

      pack_objects(hash).each do |type, value|
        value.chars.each_slice(510).map(&:join).each do |value_slice|
          length = Int.pack([value_slice].pack('H*').length)

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
        packed_value = tlv_value.handler.pack(unpacked_value)
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

        byte_length = Int.unpack(data[scanner_index, 2]) * 2
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
        unpacked_value = tlv_value.handler.unpack(packed_value)
        memo[unpacked_key] = unpacked_value
      end
    end
  end
end
