require_relative '../rack/handler/hap_server'
Rack::Handler.register 'hap_server', RubyHome::Rack::Handler::HAPServer

module RubyHome
  module HTTP
    class Application < Sinatra::Base
      Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require file }

      disable :protection
      disable :logging
      set :bind, '0.0.0.0'
      set :quiet, true
      set :server, :hap_server
      set :server_settings, AcceptCallback: -> (sock) do
        self.set :request_id, sock.object_id
      end

      use AccessoriesController
      use CharacteristicsController
      use PairSetupsController
      use PairVerifiesController
      use PairingsController
    end
  end
end
