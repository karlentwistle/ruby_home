require_relative '../../tlv'

module Rubyhome
  module HTTP
    class PairingsController < ApplicationController
      post '/pairings' do
        content_type 'application/pairing+tlv8'

        case unpack_request['kTLVType_Method']
        when 3
          add_pairing
        when 4
          remove_pairing
        end
      end

      private

      def add_pairing
        pairing_params = {
          admin: !!unpack_request["kTLVType_Permissions"],
          identifier: unpack_request["kTLVType_Identifier"],
          public_key: unpack_request["kTLVType_PublicKey"]
        }
        Pairing.create!(pairing_params)
        TLV.pack({'kTLVType_State' => 2})
      end

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
    end
  end
end
