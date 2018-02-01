require_relative '../../tlv'

module Rubyhome
  module HTTP
    class ApplicationController < Sinatra::Base
      def unpack_request
        @_unpack_request ||= begin
          request.body.rewind
          TLV.unpack(request.body.read)
        end
      end

      def accessory_info
        Application.accessory_info
      end

      def request_id
        Application.request_id
      end

      def cache
        GlobalCache.instance[request_id] ||= Cache.new
      end
    end
  end
end
