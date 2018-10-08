module RubyHome
  class VerifySRPService
    def initialize(public_key: , device_proof: , srp_session: )
      @device_proof = device_proof
      @srp_session = srp_session
      @public_key = public_key
    end

    def valid?
      return false unless public_key
      return false unless device_proof
      return false unless srp_session
      return false unless valid_session?

      true
    end

    def session_key
      srp_verifier.K
    end

    def server_proof
      verify_session_bytes
    end

    private

    def valid_session?
      !!verify_session
    end

    def verify_session_bytes
      [verify_session].pack('H*')
    end

    def verify_session
      @_verify_session ||= srp_verifier.verify_session(
        srp_session.merge({A: public_key_bytes}),
        device_proof_bytes
      )
    end

    def public_key_bytes
      public_key.unpack1('H*')
    end

    def device_proof_bytes
      device_proof.unpack1('H*')
    end

    def srp_verifier
      @_verifier ||= RubyHome::SRP::Verifier.new
    end

    attr_reader :public_key, :device_proof, :srp_session
  end
end
