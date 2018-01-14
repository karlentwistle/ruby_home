require_relative '../../tlv'

module Rubyhome
  module HTTP
    class PairingsController
      def initialize(request, settings)
        @request = request
        @settings = settings
      end

      def create
        case unpack_request['kTLVType_Method']
        when 4
          remove_pairing
        end
      end

      private

      attr_reader :request, :settings

      def remove_pairing
        TLV.pack({'kTLVType_State' => 2})
      end

      def unpack_request
        @_unpack_request ||= begin
          request.body.rewind
          TLV.unpack(request.body.read)
        end
      end

      def accessory_info
        settings.accessory_info
      end

      def cache
        Cache.instance
      end
    end
  end
end


