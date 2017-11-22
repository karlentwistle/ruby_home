require 'sinatra/base'

module Rubyhome
  class Server < Sinatra::Base

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
      puts request.inspect
      'setup'
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
