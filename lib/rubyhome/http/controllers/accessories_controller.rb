require_relative '../../tlv'

module Rubyhome
  module HTTP
    class AccessoriesController < ApplicationController
      get '/accessories' do
        content_type 'application/hap+json'
        status 401
        JSON.generate({"status" => -70401})
      end
    end
  end
end
