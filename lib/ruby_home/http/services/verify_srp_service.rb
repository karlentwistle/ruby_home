module RubyHome
  class VerifySRPService
    def initialize(device_proof:, public_key:, srp_session:)
      @device_proof_bytes = device_proof.to_s.unpack1("H*")
      @public_key_bytes = public_key.to_s.unpack1("H*")
      @srp_session = srp_session
    end

    def run
      if valid_session?
        OpenStruct.new(
          success?: true,
          session_key: session_key,
          server_proof: verify_session_bytes
        )
      else
        OpenStruct.new(success?: false)
      end
    end

    private

    def valid_session?
      !!verify_session
    end

    def session_key
      srp_verifier.K
    end

    def verify_session_bytes
      [verify_session].pack("H*")
    end

    def verify_session
      srp_verifier.verify_session(
        srp_session.merge({A: public_key_bytes}),
        device_proof_bytes
      )
    end

    def srp_verifier
      @_verifier ||= RubyHome::SRP::Verifier.new
    end

    attr_reader :public_key_bytes, :device_proof_bytes, :srp_session
  end
end
