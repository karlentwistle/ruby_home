require 'bindata'
require 'dnssd'
require 'hkdf'
require 'oj'
require 'rack'
require 'rbnacl/libsodium'
require 'request_store'
require 'ruby_home-srp'
require 'sinatra/base'
require 'webrick'
require 'wisper'

module RubyHome
  Dir[File.dirname(__FILE__) + '/ruby_home/**/*.rb'].each { |file| require file }

  class << self
    def run
      trap 'INT'  do shutdown end
      trap 'TERM' do shutdown end

      greet
      start
    end

    def start
      threads << Thread.start { dns_service.register }
      threads << Thread.start { http_server.run }
      threads.each(&:join)
    end

    def threads
      @@_threads ||= []
    end

    def shutdown
      threads.each(&:exit)
    end

    def dns_service
      @@_dns_service ||= RubyHome::DNS::Service.new(http_server.port)
    end

    def http_server
      @@_http_server ||= RubyHome::HTTP::Application.new
    end

    def greet
      Greeter.run
    end
  end
end
