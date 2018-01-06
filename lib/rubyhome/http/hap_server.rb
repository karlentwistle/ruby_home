require 'webrick/httpserver'
require_relative 'hap_request'
require_relative 'hap_response'

module WEBrick
  HTTPRequest = Rubyhome::HTTP::HAPRequest
  HTTPResponse = Rubyhome::HTTP::HAPResponse
end

module Rubyhome
  module HTTP
    HAPServer = Class.new(WEBrick::HTTPServer)
  end
end
