require_relative 'application_controller'

module RubyHome
  module HTTP
    class AccessoriesController < ApplicationController
      get '/accessories' do
        content_type 'application/hap+json'

        if cache[:controller_to_accessory_key] && cache[:accessory_to_controller_key]
          AccessorySerializer.new(identifier_cache.accessories).serialized_json
        else
          status 401
          JSON.generate({"status" => -70401})
        end
      end
    end
  end
end
