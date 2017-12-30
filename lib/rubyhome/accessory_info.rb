require "singleton"
require "rbnacl/libsodium"
require_relative "device_id"

module Rubyhome
  class AccessoryInfo
    include Singleton

    def device_id
      @_device_id ||= DeviceID.generate
    end

    def username
      'Pair-Setup'
    end

    def password
      '031-45-154'
    end

    def signing_key
      @_signing_key ||= RbNaCl::Signatures::Ed25519::SigningKey.generate
    end
  end
end
