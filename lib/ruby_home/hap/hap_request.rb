module RubyHome
  module HAP
    class HAPRequest < WEBrick::HTTPRequest
      def initialize(config, session:)
        @session = session
        super(config)
      end

      def meta_vars
        super.merge(
          {"REQUEST_SESSION" => @session}
        )
      end
    end
  end
end
