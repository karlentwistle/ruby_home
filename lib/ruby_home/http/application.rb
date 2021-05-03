Dir[File.dirname(__FILE__) + "/controllers/*.rb"].each { |file| require file }

module RubyHome
  module HTTP
    class Application
      def self.rack_builder
        ::Rack::Builder.new do
          map("/accessories") { run AccessoriesController }
          map("/characteristics") { run CharacteristicsController }
          map("/identify") { run IdentifyController }
          map("/pair-setup") { run PairSetupsController }
          map("/pair-verify") { run PairVerifiesController }
          map("/pairings") { run PairingsController }
        end
      end
    end
  end
end
