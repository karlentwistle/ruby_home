module RubyHome
  module HTTP
    module UUIDHelper
      APPLE_BASE_UUID = -'0000-1000-8000-0026BB765291'

      def uuid_short_form(uuid)
        return uuid unless apple_defined_uuid?(uuid)

        trim_leading_zeros(uuid[0...8])
      end

      def apple_defined_uuid?(uuid)
        uuid.end_with?(APPLE_BASE_UUID)
      end

      def trim_leading_zeros(input)
        input.remove(/^0*/)
      end
    end
  end
end
