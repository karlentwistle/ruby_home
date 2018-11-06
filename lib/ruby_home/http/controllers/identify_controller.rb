require_relative 'application_controller'

module RubyHome
  module HTTP
    class IdentifyController < ApplicationController
      post '/' do
        if accessory_info.paired?
          paired_accessory
        else
          unpaired_accessory
        end
      end

      private

        def paired_accessory
          status 400
          content_type 'application/hap+json'
          JSON.generate({"status" => -70401})
        end

        def unpaired_accessory
          halt 204
        end
    end
  end
end
