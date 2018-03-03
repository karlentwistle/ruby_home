require_relative '../../tlv'

module Rubyhome
  module HTTP
    class AccessoriesController < ApplicationController
      get '/accessories' do
        content_type 'application/hap+json'

        if cache[:controller_to_accessory_key] && cache[:accessory_to_controller_key]
          path = File.expand_path('../../public/example_accessory.json', __FILE__)
          data = File.read(path)
        else
          status 401
          JSON.generate({"status" => -70401})
        end
      end
    end
  end
end
