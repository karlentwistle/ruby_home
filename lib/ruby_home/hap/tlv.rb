module RubyHome
  module HAP
    module TLV
      ERROR_TYPES = {
        unknown: 1,
        authentication: 2,
        backoff: 3,
        max_peers: 4,
        max_tries: 5,
        unavailable: 6,
        busy: 7,
      }.freeze
      TYPE_ERRORS = ERROR_TYPES.invert.freeze

      NAME_TYPES = {
        method: 0,
        identifier: 1,
        salt: 2,
        public_key: 3,
        proof: 4,
        encrypted_data: 5,
        state: 6,
        error: 7,
        retry_delay: 8,
        certificate: 9,
        signature: 10,
        permissions: 11,
        fragment_data: 12,
        fragment_last: 13,
      }.freeze
      TYPE_NAMES = NAME_TYPES.invert.freeze

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

      def self.read(input)
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

      def self.encode(hash)
        hash.to_hash.each_with_object(String.new) do |(key, value), memo|
          type_id = NAME_TYPES[key]
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
