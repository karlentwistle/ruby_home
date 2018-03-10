require 'sinatra/base'
require_relative '../rack/handler/hap_server'
require_relative 'cache'

Rack::Handler.register 'hap_server', Rubyhome::Rack::Handler::HAPServer

module Rubyhome
  module HTTP
    class Application < Sinatra::Base
      Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require file }

      disable :protection
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
