require_relative '../rack/handler/hap_server'
Rack::Handler.register 'hap_server', RubyHome::Rack::Handler::HAPServer

module RubyHome
  module HTTP
    class Application < Sinatra::Base
      def self.accept_callback
        -> (socket) do
          RequestStore.store[socket] = {}
          set :socket, socket
        end
      end

      set :bind, '0.0.0.0'
      set :quiet, true
      set :server, :hap_server
      set :server_settings, AcceptCallback: self.accept_callback, ServerSoftware: 'RubyHome'

      Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require file }

      use AccessoriesController
      use CharacteristicsController
      use PairSetupsController
      use PairVerifiesController
      use PairingsController
    end
  end
end
