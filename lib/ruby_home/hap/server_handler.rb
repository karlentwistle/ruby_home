module RubyHome
  module HAP
    class RackHandler < ::Rack::Handler::WEBrick
      def self.run(app, options={})
        @server = Server.new(options)
        @server.mount "/", RackHandler, app
        yield @server if block_given?
        @server
      end
    end

    class ServerHandler
      def initialize(configuration: )
        @configuration = configuration
      end

      def run
        server.start
      end

      def shutdown
        server.shutdown
      end

      def server
        @server ||= RackHandler.run(
          HTTP::Application.rack_builder,
          server_options
        )
      end

      def server_options
        {
          Port: port,
          Host: bind_address,
          ServerSoftware: 'RubyHome',
          Logger: server_logger,
          AccessLog: access_logger
        }
      end

      def server_logger
        if ENV['DEBUG']
          WEBrick::Log::new(STDOUT, WEBrick::BasicLog::DEBUG)
        else
          WEBrick::Log::new("/dev/null", WEBrick::BasicLog::WARN)
        end
      end

      def access_logger
        if ENV['DEBUG']
          [
            [ STDOUT, WEBrick::AccessLog::COMMON_LOG_FORMAT ],
            [ STDOUT, WEBrick::AccessLog::REFERER_LOG_FORMAT ]
          ]
        else
          []
        end
      end

      def bind_address
        configuration.host
      end

      def port
        configuration.port
      end

      attr_reader :configuration
    end
  end
end


