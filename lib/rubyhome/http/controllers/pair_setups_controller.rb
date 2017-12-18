require_relative '../../srp'
require_relative '../../tlv'

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

        auth = srp_verifier.generate_userauth(username, password)

        verifier = auth[:verifier]
        salt = auth[:salt]

        challenge_and_proof = srp_verifier.get_challenge_and_proof(username, verifier, salt)
        store_proof(challenge_and_proof[:proof])

        TLV.pack({
          'kTLVType_Salt' => challenge_and_proof[:challenge][:salt],
          'kTLVType_PublicKey' => challenge_and_proof[:challenge][:B],
          'kTLVType_State' => 2
        })
      end

      def srp_verify_response
        proof = retrieve_proof.dup
        proof[:A] = unpack_request['kTLVType_PublicKey']

        client_m1_proof = unpack_request['kTLVType_Proof']
        server_m2_proof = srp_verifier.verify_session(proof, unpack_request['kTLVType_Proof'])

        TLV.pack({
          'kTLVType_State' => 4,
          'kTLVType_Proof' => server_m2_proof
        })
      end

      def unpack_request
        @_unpack_request ||= begin
          request.body.rewind
          TLV.unpack(request.body.read)
        end
      end

      def srp_verifier
        @_verifier ||= Rubyhome::SRP::Verifier.new
      end

      def store_proof(proof)
        Cache.instance[:proof] = proof
      end

      def retrieve_proof
        Cache.instance[:proof]
      end
    end
  end
end
