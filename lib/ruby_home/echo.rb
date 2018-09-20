require 'nio'
require 'socket'
require 'rack/test'
require 'webrick'

module RubyHome
  class EchoServer
    def initialize(host, port, socket_store)
      @port = port
      @host = host
      @socket_store = socket_store
      @selector = NIO::Selector.new
    end

    attr_reader :port, :host, :socket_store

    def run
      puts "Listening on #{host}:#{port}"
      @server = TCPServer.new(host, port)

      monitor = @selector.register(@server, :r)
      monitor.value = proc { accept }

      loop do
        @selector.select { |monitor| monitor.value.call(monitor) }
      end
    end

    private

    def accept
      socket = @server.accept
      _, port, host = socket.peeraddr
      puts "*** #{host}:#{port} connected"

      monitor = @selector.register(socket, :r)
      monitor.value = proc { read(socket) }
    end

    def upstream
      @_upstream ||= RubyHome::HTTP::Application.run
    end

    def read(socket)
      return close(socket) if socket.eof?

      socket_store[socket] ||= {}

      request = RubyHome::HTTP::HAPRequest.new(WEBrick::Config::HTTP, socket)
      response = RubyHome::HTTP::HAPResponse.new(WEBrick::Config::HTTP, socket)

      request.parse(socket)

      response.received_encrypted_request = request.received_encrypted_request?
      response.request_method = request.request_method
      response.request_uri = request.request_uri
      response.request_http_version = request.http_version
      response.keep_alive = request.keep_alive?

      upstream.service(request, response)

      if request.request_line
        if request.keep_alive? && response.keep_alive?
          request.fixup()
        end
        response.send_response(socket)
      end

      return close(socket) unless request.keep_alive?
      return close(socket) unless response.keep_alive?
    rescue EOFError
      close(socket)
    end

    def close(socket)
      _, port, host = socket.peeraddr
      puts "*** #{host}:#{port} disconnected"
      @selector.deregister(socket)
      socket_store.delete(socket)
      socket.close
    end
  end
end

