require_relative "application_controller"

module RubyHome
  module HTTP
    class AccessoriesController < ApplicationController
      get "/" do
        content_type "application/hap+json"

        if session.sufficient_privileges?
          AccessorySerializer.new(identifier_cache.accessories).serialized_json
        else
          status 401
          JSON.generate({"status" => -70401})
        end
      end
    end
  end
end
