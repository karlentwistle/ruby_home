require_relative '../../srp'
require_relative '../../tlv'

module Rubyhome
  module HTTP
    class PairSetupsController

      def initialize(request)
        @request = request
      end

      def create
        request.body.rewind

        username = 'Pair-Setup'
        password = '101-48-005'
        prime_length = 3072

        auth = Rubyhome::SRP::Verifier.new.generate_userauth(username, password)

        # Server retrieves user's verifier and salt from the database.
        verifier = auth[:verifier]
        salt = auth[:salt]

        # Server generates challenge for the client.
        srp = SRP::Verifier.new

        b = srp.generate_B(verifier)



        TLV.pack({
          'kTLVType_Salt' => salt,
          'kTLVType_PublicKey' => b,
          'kTLVType_State' => 2
        })
      end

      private

      attr_reader :request

    end
  end
end
