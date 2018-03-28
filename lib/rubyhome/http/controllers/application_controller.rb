module Rubyhome
  module HTTP
    class ApplicationController < Sinatra::Base
      disable :protection

      def unpack_request
        @_unpack_request ||= begin
          request.body.rewind
          TLV.unpack(request.body.read)
        end
      end

      def json_body
        @_json_body ||= begin
          request.body.rewind
          JSON.parse(request.body.read)
        end
      end

      def accessory_info
        AccessoryInfo
      end

      def identifier_cache
        IdentifierCache
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
