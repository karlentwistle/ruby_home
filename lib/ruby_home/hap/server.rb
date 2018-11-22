module RubyHome
  module HAP
    class Server
      def initialize(host, port)
        @port = port
        @host = host
        @selector = NIO::Selector.new
      end

      attr_reader :port, :host

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

      SESSIONS = {}

      def accept
        socket = @server.accept
        monitor = @selector.register(socket, :r)
        monitor.value = proc { read(socket) }
      end

      def upstream
        @_upstream ||= HTTP::Application.run
      end

      def webrick_config
        @_webrick_config ||= WEBrick::Config::HTTP
      end

      def read(socket)
        return close(socket) if socket.eof?

        session = SESSIONS[socket] ||= Session.new(socket)

        request = HAPRequest.new(webrick_config)
        response = HAPResponse.new(webrick_config)

        request.parse(session)

        response.request_method = request.request_method
        response.request_uri = request.request_uri
        response.request_http_version = request.http_version
        response.keep_alive = request.keep_alive?

        upstream.service(request, response)

        if request.request_line
          if request.keep_alive? && response.keep_alive?
            request.fixup()
          end
          response.send_response(session)
        end

        return close(socket) unless request.keep_alive?
        return close(socket) unless response.keep_alive?
      rescue Errno::ECONNRESET, Errno::ECONNABORTED,
             Errno::EPROTO, Errno::EINVAL, Errno::EHOSTUNREACH
        close(socket)
      rescue EOFError
        close(socket)
      end

      def close(socket)
        @selector.deregister(socket)
        socket.close
      end
    end
  end
end

