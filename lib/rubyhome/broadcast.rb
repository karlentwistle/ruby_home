require 'dnssd'
require_relative 'dns/text_record'
require_relative 'http/application'
require_relative 'accessory_info'

Thread.abort_on_exception = true

module Rubyhome
  class Broadcast
    def self.run
      threads = []
      threads << Thread.new do
        dns_service
      end
      threads.each(&:join)

      http_server.run!
    end

    def self.dns_service
      @_dns_service ||= begin
        name = "RubyHome"
        type = "_hap._tcp"
        port = http_server.port
        text_record = TextRecord.new(accessory_info: AccessoryInfo.instance)
        DNSSD::Service.register name, type, nil, port, nil, text_record
      end
    end

    def self.http_server
      @_http_server ||= begin
        server = Rubyhome::HTTP::Application
        server.enable :logging

        server.set :bind, '0.0.0.0'
        server.set :quiet, true
        server.set :accessory_info, AccessoryInfo.instance
        server
      end
    end
  end
end
