require_relative '../../tlv'

module Rubyhome
  module HTTP
    class ApplicationController < Sinatra::Base
      set :accessory_info, -> { Application.accessory_info }

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
