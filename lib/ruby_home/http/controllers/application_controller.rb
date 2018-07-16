module RubyHome
  module HTTP
    class ApplicationController < Sinatra::Base
      disable :protection

      def unpack_request
        @_unpack_request ||= _unpack_request
      end

      def json_body
        @_json_body ||= _unpack_json
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

      private

      def rewind_request
        if request.body.size > 0
          request.body.rewind
        end
      end

      def _unpack_request
        HAP::TLV.read(request.body.read).tap do |request_body|
          logger.debug request_body
        end
      end

      def _unpack_json
        rewind_request
        JSON.parse(request.body.read).tap do |request_body|
          logger.debug request_body
        end
      end
    end
  end
end
