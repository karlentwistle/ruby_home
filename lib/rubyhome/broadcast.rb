require 'dnssd'
require_relative 'dns/text_record'
require_relative 'http/application'

Thread.abort_on_exception = true

module Rubyhome
  class Broadcast

    def self.run
      name = "RubyHome"
      type = "_hap._tcp"
      text_record = TextRecord.new

      server = Rubyhome::HTTP::Application
      port = server.port
      server.set :bind, '0.0.0.0'
      server.set :quiet, true

      threads = []
      threads << Thread.new do
        DNSSD::Service.register name, type, nil, port, nil, text_record
      end
      threads.each(&:join)

      server.run!
    end

  end
end
