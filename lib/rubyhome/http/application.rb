require 'active_record'
require 'sinatra/base'
require_relative '../rack/handler/hap_server'
require_relative 'cache'
require_relative 'controllers/accessories_controller'
require_relative 'controllers/pair_setups_controller'
require_relative 'controllers/pair_verifies_controller'
require_relative 'controllers/pairings_controller'
require_relative 'models/pairing'

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "rubyhome.sqlite3.db"
)

module Rubyhome
  module HTTP
    class Application < Sinatra::Base
      configure do
        ::Rubyhome::Cache.instance
      end

      ::Rack::Handler.register 'hap_server', Rubyhome::Rack::Handler::HAPServer
      set :server, :hap_server

      get '/accessories' do
        content_type 'application/hap+json'
        AccessoriesController.new(request, settings).index
      end

      get '/characteristics' do
        puts request.inspect
        'characteristics'
      end

      put '/characteristics' do
        puts request.inspect
        'characteristics'
      end

      post '/identify' do
        puts request.inspect
        'identify'
      end

      post '/pair-setup' do
        content_type 'application/pairing+tlv8'
        PairSetupsController.new(request, settings).create
      end

      post '/pair-verify' do
        content_type 'application/pairing+tlv8'
        PairVerifiesController.new(request, settings).create
      end

      post '/pairings' do
        content_type 'application/pairing+tlv8'
        PairingsController.new(request, settings).create
      end
    end
  end
end
