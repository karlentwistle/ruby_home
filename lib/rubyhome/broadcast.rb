require_relative 'dns/service'
require_relative 'http/application'

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
        service = Rubyhome::DNS::Service.new(http_server.port)

        service.register
        service
      end
    end

    def self.http_server
      @_http_server ||= Rubyhome::HTTP::Application
    end
  end
end
