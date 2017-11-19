require 'dnssd'
require_relative 'dns/text_record'

module Rubyhome
  class Broadcast
    def self.run
      http = TCPServer.new nil, 8080
      name = "RubyHome"
      service = "hap"
      text_record = TextRecord.new

      DNSSD.announce http, name, service, text_record

      loop do
        socket = http.accept
        peeraddr = socket.peeraddr
        puts "Connection from %s:%d" % socket.peeraddr.values_at(2, 1)
      end
    end
  end
end
