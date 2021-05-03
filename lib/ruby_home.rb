require "dnssd"
require "facets/hash/slice"
require "hkdf"
require "oj"
require "rack"
require "rbnacl"
require "ruby_home/srp"
require "ruby_home/tlv"
require "securerandom"
require "sinatra/base"
require "socket"
require "webrick"
require "wisper"
require "yaml"

module RubyHome
  [
    "/ruby_home/hap/**/*.rb",
    "/ruby_home/http/**/*.rb",
    "/ruby_home/factories/**/*.rb",
    "/ruby_home/dns/**/*.rb",
    "/ruby_home/*.rb"
  ].each do |pattern|
    Dir[File.dirname(__FILE__) + pattern].each { |file| require file }
  end

  class << self
    def configuration
      @_configuration ||= Configuration.new
    end

    alias_method :config, :configuration

    def configure
      yield configuration
    end

    def run
      trap "INT" do shutdown end
      trap "TERM" do shutdown end

      greet
      start
    end

    def start
      threads << Thread.start { dns_service.register }
      threads << Thread.start { hap_server.run }
      threads.each(&:join)
    end

    def threads
      @_threads ||= []
    end

    def shutdown
      hap_server.shutdown

      threads.each(&:exit)
    end

    def dns_service
      @_dns_service ||= DNS::Service.new(configuration: configuration)
    end

    def hap_server
      @_hap_server ||= HAP::ServerHandler.new(configuration: configuration)
    end

    def greet
      Greeter.run
    end
  end
end
