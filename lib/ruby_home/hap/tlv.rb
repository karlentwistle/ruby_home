require 'bindata'

module RubyHome
  module HAP
    module TLV
      extend self

      TYPE_NAMES = {
        0 => 'kTLVType_Method',
        1 => 'kTLVType_Identifier',
        2 => 'kTLVType_Salt',
        3 => 'kTLVType_PublicKey',
        4 => 'kTLVType_Proof',
        5 => 'kTLVType_EncryptedData',
        6 => 'kTLVType_State',
        7 => 'kTLVType_Error',
        8 => 'kTLVType_RetryDelay',
        9 => 'kTLVType_Certificate',
       10 => 'kTLVType_Signature',
       11 => 'kTLVType_Permissions',
       12 => 'kTLVType_FragmentData',
       13 => 'kTLVType_FragmentLast',
      }.freeze
      NAME_TYPES = TYPE_NAMES.invert.freeze

      class Bytes < BinData::String; end

      class UTF8String < BinData::String
        def snapshot
          super.force_encoding('UTF-8')
        end
      end

      class TLV < BinData::Record
        uint8 :type_id, read_length: 2
        uint8 :len, read_length: 2
        choice :val, selection: :type_id do
          uint8       0,  read_length: :len
          utf8_string 1,  read_length: :len
          bytes       2,  read_length: :len
          bytes       3,  read_length: :len
          bytes       4,  read_length: :len
          bytes       5,  read_length: :len
          uint8       6,  read_length: :len
          uint8       7,  read_length: :len
          uint8       8,  read_length: :len
          bytes       9,  read_length: :len
          bytes      10,  read_length: :len
          uint8      11,  read_length: :len
          bytes      12,  read_length: :len
          bytes      13,  read_length: :len
        end
      end

      READER = BinData::Array.new(type: :tlv, read_until: :eof)

      def read(input)
        READER.clear
        READER.read(input)
        READER.snapshot.each_with_object({}) do |(hash), memo|
          type  = TYPE_NAMES[hash[:type_id]]
          value = hash[:val]

          if memo[type]
            memo[type] << value
          else
            memo[type] = value
          end
        end
      end

      def encode(hash)
        hash.to_hash.each_with_object(String.new) do |(key, value), memo|
          if value.is_a?(String)
            value.scan(/.{1,255}/m)
          else
            [value]
          end.each do |frame_value|
            tlv = TLV.new(type_id: NAME_TYPES[key], val: frame_value)
            tlv.len = tlv.val.to_binary_s.length
            memo << tlv.to_binary_s
          end
        end
      end
    end
  end
end
