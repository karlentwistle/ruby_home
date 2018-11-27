module RubyHome
  module HAP
    class HAPRequest < WEBrick::HTTPRequest
      attr_accessor :session

      def meta_vars
        super.merge(
          { "REQUEST_SESSION" => session }
        )
      end
    end
  end
end
