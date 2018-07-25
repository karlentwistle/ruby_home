Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require file }

module RubyHome
  module HTTP
    class Application
      def accept_callback
        -> (socket) do
          RequestStore.store[socket] = {}
        end
      end

      def run
        RubyHome::Rack::Handler::HAPServer.run rack_builder, Port: port, Host: bind_address, ServerSoftware: 'RubyHome', AcceptCallback: accept_callback
      end

      def port
        @_port ||= Integer(ENV['PORT'] && !ENV['PORT'].empty? ? ENV['PORT'] : 4567)
      end

      def bind_address
        '0.0.0.0'
      end

      def rack_builder
        ::Rack::Builder.new do
          use AccessoriesController
          use CharacteristicsController
          use PairSetupsController
          use PairVerifiesController
          run PairingsController
        end
      end
    end
  end
end
