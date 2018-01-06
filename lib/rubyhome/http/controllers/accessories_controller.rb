require_relative '../../tlv'
require "x25519"

module Rubyhome
  module HTTP
    class AccessoriesController
      def initialize(request, settings)
        @request = request
        @settings = settings
      end

      def index
        { "accessories" => [] }.to_json
      end
    end
  end
end
