require 'sinatra/base'
require_relative 'controllers/pair_setups_controller'

module Rubyhome
  module HTTP
    class Application < Sinatra::Base
      enable :logging

      get '/accessories' do
        puts request.inspect
        'accessories'
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
        PairSetupsController.new(request).create
      end

      post '/pair-verify' do
        puts request.inspect
        'verify'
      end

      post '/pairings' do
        puts request.inspect
        'pairings'
      end

    end
  end
end


