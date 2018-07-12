module RubyHome
  module HAP
    module TLV
      extend self

      ERROR_CODES = {
        1 => 'kTLVError_Unknown',
        2 => 'kTLVError_Authentication',
        3 => 'kTLVError_Backoff',
        4 => 'kTLVError_MaxPeers',
        5 => 'kTLVError_MaxTries',
        6 => 'kTLVError_Unavailable',
        7 => 'kTLVError_Busy',
      }.freeze

      TYPE_NAMES = {
        0 => :method,
        1 => :identifier,
        2 => :salt,
        3 => :public_key,
        4 => :proof,
        5 => :encrypted_data,
        6 => :state,
        7 => :error,
        8 => :retry_delay,
        9 => :certificate,
       10 => :signature,
       11 => :permissions,
       12 => 'kTLVType_FragmentData',
       13 => 'kTLVType_FragmentLast',
      }.freeze

      class Bytes < BinData::String; end

      class UTF8String < BinData::String
        def snapshot
          super.force_encoding('UTF-8')
        end
      end

      class Payload < BinData::Choice
        bytes :default, read_length: :len

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

      class TLV < BinData::Record
        uint8 :type_id, read_length: 2
        uint8 :len, read_length: 2
        payload :val, selection: :type_id
      end

      READER = BinData::Array.new(type: :tlv, read_until: :eof)

      def read(input)
        READER.clear
        READER.read(input)
        READER.snapshot.each_with_object({}) do |(hash), memo|
          type = TYPE_NAMES[hash[:type_id]]
          next unless type

          if memo[type]
            memo[type] << hash[:val]
          else
            memo[type] = hash[:val]
          end
        end
      end

      def encode(hash)
        hash.to_hash.each_with_object(String.new) do |(key, value), memo|
          type_id = TYPE_NAMES.invert[key]
          next unless type_id

          if value.is_a?(String)
            value.scan(/.{1,255}/m)
          else
            [value]
          end.each do |frame_value|
            tlv = TLV.new(type_id: type_id, val: frame_value).tap do |tlv|
              tlv.len = tlv.val.to_binary_s.length
            end
            memo << tlv.to_binary_s
          end
        end
      end
    end
  end
end
