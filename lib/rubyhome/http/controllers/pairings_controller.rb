require_relative '../../tlv'

module Rubyhome
  module HTTP
    class PairingsController < Sinatra::Base
      post '/pairings' do
        content_type 'application/pairing+tlv8'

        case unpack_request['kTLVType_Method']
        when 4
          remove_pairing
        end
      end

      private

      def remove_pairing
        response["connection"] = "close"
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
    end
  end
end
