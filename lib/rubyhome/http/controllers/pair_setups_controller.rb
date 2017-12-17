require_relative '../../srp'
require_relative '../../tlv'
require 'byebug'

module Rubyhome
  module HTTP
    class PairSetupsController
      def initialize(request)
        @request = request
      end

      def create
        case unpack_request['kTLVType_State']
        when 1
          srp_start_response
        when 3
          srp_verify_response
        end
      end

      private

      attr_reader :request

      def srp_start_response
        username = 'Pair-Setup'
        password = '031-45-154'

        srp = Rubyhome::SRP::Verifier.new
        auth = srp.generate_userauth(username, password)

        verifier = auth[:verifier]
        salt = auth[:salt]

        challenge_and_proof = srp.get_challenge_and_proof(username, verifier, salt)

        data = Marshal.dump(challenge_and_proof[:proof])
        File.open('/Users/karl/gems/rubyhome/bla', 'w') { |file| file.write(data) }

        TLV.pack({
          'kTLVType_Salt' => challenge_and_proof[:challenge][:salt],
          'kTLVType_PublicKey' => challenge_and_proof[:challenge][:B],
          'kTLVType_State' => 2
        })
      end

      def srp_verify_response
        file = File.read('/Users/karl/gems/rubyhome/bla')
        data = Marshal.load(file)

        srp = Rubyhome::SRP::Verifier.new

        proof = data
        proof[:A] = unpack_request['kTLVType_PublicKey']

        srp.verify_session(proof, unpack_request['kTLVType_Proof'])

        TLV.pack({
          'kTLVType_State' => 4
        })
      end

      def unpack_request
        @_unpack_request ||= begin
          request.body.rewind
          TLV.unpack(request.body.read)
        end
      end
    end
  end
end
