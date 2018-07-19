require_relative 'application_controller'

module RubyHome
  module HTTP
    class PairingsController < ApplicationController
      post '/pairings' do
        content_type 'application/pairing+tlv8'

        case unpack_request[:method]
        when 3
          add_pairing
        when 4
          remove_pairing
        end
      end

      private

      def add_pairing
        pairing_params = {
          admin: !!unpack_request[:permissions],
          identifier: unpack_request[:identifier],
          public_key: unpack_request[:public_key].unpack1('H*')
        }
        accessory_info.add_paired_client pairing_params

        tlv state: 2
      end

      def remove_pairing
        accessory_info.remove_paired_client(unpack_request[:identifier])
        RubyHome::Broadcast.dns_service.update

        response['connection'] = 'close'
        tlv state: 2
      end
    end
  end
end
