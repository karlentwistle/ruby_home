class StartSRPService
  def initialize(username: , password:)
    @username = username
    @password = password
  end

  def salt_bytes
    [salt].pack('H*')
  end

  def public_key_bytes
    [public_key].pack('H*')
  end

  def proof
    challenge_and_proof[:proof]
  end

  private

  def salt
    user_auth[:salt]
  end

  def public_key
    challenge[:B]
  end

  def challenge
    challenge_and_proof[:challenge]
  end

  def challenge_and_proof
    srp_verifier.get_challenge_and_proof(username, user_auth[:verifier], user_auth[:salt])
  end

  def user_auth
    @_user_auth ||= srp_verifier.generate_userauth(username, password)
  end

  def srp_verifier
    @_verifier ||= RubyHome::SRP::Verifier.new
  end

  attr_reader :username, :password
end
