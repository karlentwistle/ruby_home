module RubyHome
  module HAP
    class Server < ::WEBrick::HTTPServer
      def run(sock)
        session = Session.new(sock)

        while true
          req = HAPRequest.new(@config, session: session)
          res = HAPResponse.new(@config)
          server = self
          begin
            timeout = @config[:RequestTimeout]
            while timeout > 0
              break if sock.to_io.wait_readable(0.5)
              break if @status != :Running
              timeout -= 0.5
            end
            raise ::WEBrick::HTTPStatus::EOFError if timeout <= 0 || @status != :Running
            raise ::WEBrick::HTTPStatus::EOFError if sock.eof?

            req.parse(session.parse)

            res.request_method = req.request_method
            res.request_uri = req.request_uri
            res.request_http_version = req.http_version
            res.keep_alive = req.keep_alive?
            server = lookup_server(req) || self

            server.service(req, res)
          rescue ::WEBrick::HTTPStatus::EOFError, ::WEBrick::HTTPStatus::RequestTimeout => ex
            res.set_error(ex)
          rescue ::WEBrick::HTTPStatus::Error => ex
            @logger.error(ex.message)
            res.set_error(ex)
          rescue ::WEBrick::HTTPStatus::Status => ex
            res.status = ex.code
          rescue StandardError => ex
            @logger.error(ex)
            res.set_error(ex, true)
          ensure
            if req.request_line
              if req.keep_alive? && res.keep_alive?
                req.fixup()
              end
              res.send_response(session)
              server.access_log(@config, req, res)
            end
          end
          break unless req.keep_alive?
          break unless res.keep_alive?
        end
      end
    end
  end
end
