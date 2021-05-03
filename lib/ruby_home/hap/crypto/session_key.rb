module RubyHome
  module HAP
    module Crypto
      class SessionKey
        def initialize(shared_secret)
          @shared_secret = shared_secret
        end

        def controller_to_accessory_key
          @controller_to_accessory_key ||= generate_shared_secret_key(WRITE)
        end

        def accessory_to_controller_key
          @accessory_to_controller_key ||= generate_shared_secret_key(READ)
        end

        private

        SALT = -"Control-Salt"
        READ = -"Control-Read-Encryption-Key"
        WRITE = -"Control-Write-Encryption-Key"

        attr_reader :shared_secret

        def generate_shared_secret_key(info)
          Crypto::HKDF.new(info: info, salt: SALT).encrypt(shared_secret)
        end
      end
    end
  end
end
