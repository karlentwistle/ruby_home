module RubyHome
  module HTTP
    class HAPServer < WEBrick::HTTPServer
      def run(socket)
        while true
          res = RubyHome::HTTP::HAPResponse.new(@config, socket: socket)
          req = RubyHome::HTTP::HAPRequest.new(@config, socket: socket)
          server = self
          begin
            timeout = @config[:RequestTimeout]
            while timeout > 0
              break if socket.to_io.wait_readable(0.5)
              break if @status != :Running
              timeout -= 0.5
            end
            raise WEBrick::HTTPStatus::EOFError if timeout <= 0 || @status != :Running
            raise WEBrick::HTTPStatus::EOFError if socket.eof?
            req.parse(socket)
            res.received_encrypted_request = req.received_encrypted_request?
            res.request_method = req.request_method
            res.request_uri = req.request_uri
            res.request_http_version = req.http_version
            res.keep_alive = req.keep_alive?
            server = lookup_server(req) || self
            if callback = server[:RequestCallback]
              callback.call(req, res)
            elsif callback = server[:RequestHandler]
              msg = ':RequestHandler is deprecated, please use :RequestCallback'
              @logger.warn(msg)
              callback.call(req, res)
            end
            server.service(req, res)
          rescue WEBrick::HTTPStatus::EOFError, WEBrick::HTTPStatus::RequestTimeout => ex
            res.set_error(ex)
          rescue WEBrick::HTTPStatus::Error => ex
            @logger.error(ex.message)
            res.set_error(ex)
          rescue WEBrick::HTTPStatus::Status => ex
            res.status = ex.code
          rescue StandardError => ex
            @logger.error(ex)
            res.set_error(ex, true)
          ensure
            if req.request_line
              if req.keep_alive? && res.keep_alive?
                req.fixup()
              end
              res.send_response(socket)
              server.access_log(@config, req, res)
            end
          end

          break if @http_version < '1.1'
          break unless req.keep_alive?
          break unless res.keep_alive?
        end
      end
    end
  end
end
