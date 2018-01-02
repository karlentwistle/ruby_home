require 'ed25519'

class FakeAccessoryInfo
  include Singleton

  def device_id
    'CB:45:B7:61:74:8C'
  end

  def username
    'Pair-Setup'
  end

  def password
    '031-45-154'
  end

  def signing_key
    Ed25519::SigningKey.new(signing_key_hex)
  end

  private

  def signing_key_hex
    ["E2889D17DD141C3A62969E85C7092FDB1080617FECCC08A60A5001AB6C79AB97"].pack('H*')
  end
end
