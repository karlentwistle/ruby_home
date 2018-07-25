Thread.abort_on_exception = true

module RubyHome
  class Broadcast
    def self.run
      threads = []
      threads << Thread.new do
        dns_service.register
      end
      threads.each(&:join)

      http_server.run
    end

    def self.dns_service
      @_dns_service ||= RubyHome::DNS::Service.new(http_server.port)
    end

    def self.http_server
      @_http_server ||= RubyHome::HTTP::Application.new
    end
  end
end
