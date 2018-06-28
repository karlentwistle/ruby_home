module RubyHome
  module Rack
    module Handler
      class HAPServer < ::Rack::Handler::WEBrick
        def self.run(app, options={})
          environment  = ENV['RACK_ENV'] || 'development'
          default_host = environment == 'development' ? 'localhost' : nil

          options[:BindAddress] = options.delete(:Host) || default_host
          options[:Port] ||= 8080
          unless ENV['DEBUG']
            options[:Logger] = WEBrick::Log.new("/dev/null")
            options[:AccessLog] = []
          end
          @server = HTTP::HAPServer.new(options)
          @server.mount '/', Handler::HAPServer, app
          yield @server  if block_given?
          @server.start
        end
      end
    end
  end
end
