require "logger"

module RubyHome
  module HTTP
    class ApplicationController < Sinatra::Base
      disable :protection

      logger = Logger.new(STDOUT)
      logger.level = case ENV["DEBUG"]
      when "debug"
        Logger::DEBUG
      when "info"
        Logger::INFO
      else
        Logger::WARN
      end
      set :logger, logger
      enable :logging if ENV["DEBUG"]

      before do
        logger.debug "Session"
        logger.debug session.inspect
      end

      protected

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
        Accessory.all
      end

      def session
        env["REQUEST_SESSION"]
      end

      def tlv(object)
        logger.debug "Response"
        logger.debug object.inspect
        TLV.encode(object)
      end

      def logger
        if settings.respond_to?(:logger)
          settings.logger
        else
          request.logger
        end
      end

      private

      def rewind_request
        if request.body.size > 0
          request.body.rewind
        end
      end

      def request_body
        rewind_request
        request.body.read
      end

      def _unpack_request
        TLV.decode(request_body).tap do |request_tlv|
          logger.debug "Request"
          logger.debug request_tlv.inspect
        end
      end

      def _unpack_json
        JSON.parse(request_body).tap do |request_json|
          logger.debug "Request"
          logger.debug request_json.inspect
        end
      end
    end
  end
end
