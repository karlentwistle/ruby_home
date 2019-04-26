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
          AccessLog: []
        }
      end

      def server_logger
        if ENV['DEBUG'] == 'debug'
          WEBrick::Log::new(STDOUT, WEBrick::BasicLog::DEBUG)
        elsif ENV['DEBUG'] == 'info'
          WEBrick::Log::new(STDOUT, WEBrick::BasicLog::INFO)
        else
          WEBrick::Log::new("/dev/null", WEBrick::BasicLog::WARN)
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


