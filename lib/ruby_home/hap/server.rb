module RubyHome
  module HAP
    class Server < ::WEBrick::HTTPServer
      def run(sock)
        session = Session.new(sock)

        while true
          req = HAPRequest.new(@config, session: session)
          res = HAPResponse.new(@config)
          begin
            while true
              break if sock.to_io.wait_readable(0.5)
              break if @status != :Running
            end
            raise ::WEBrick::HTTPStatus::EOFError if @status != :Running
            raise ::WEBrick::HTTPStatus::EOFError if sock.eof?

            req.parse(session.parse)

            res.request_method = req.request_method
            res.request_uri = req.request_uri
            res.request_http_version = req.http_version
            res.keep_alive = req.keep_alive?

            service(req, res)
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
              access_log(@config, req, res)
            end
          end
          break unless req.keep_alive?
          break unless res.keep_alive?
        end
      end
    end
  end
end
