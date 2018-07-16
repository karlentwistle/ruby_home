module RubyHome
  module HTTP
    class ApplicationController < Sinatra::Base
      disable :protection

      def unpack_request
        @_unpack_request ||= begin
          request.body.rewind
          HAP::TLV.read(request.body.read)
        end
      end

      def json_body
        @_json_body ||= begin
          request.body.rewind
          JSON.parse(request.body.read)
        end
      end

      def accessory_info
        AccessoryInfo.instance
      end

      def identifier_cache
        IdentifierCache
      end

      def cache
        RequestStore.store[Application.socket] ||= {}
      end

      def clear_cache
        RequestStore.store[Application.socket] = {}
      end

      def tlv(object)
        HAP::TLV.encode(object)
      end
    end
  end
end
