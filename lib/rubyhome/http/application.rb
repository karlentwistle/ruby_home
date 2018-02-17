require 'active_record'
require 'sinatra/base'
require_relative 'cache'
require_relative 'models/pairing'
require_relative '../rack/handler/hap_server'
require_relative '../accessory_info'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'rubyhome.sqlite3.db'
)

Rack::Handler.register 'hap_server', Rubyhome::Rack::Handler::HAPServer

module Rubyhome
  module HTTP
    class Application < Sinatra::Base
      Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require file }

      set :server, :hap_server
      set :bind, '0.0.0.0'
      set :quiet, true
      set :accessory_info, AccessoryInfo.instance
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
