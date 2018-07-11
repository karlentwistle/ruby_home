require_relative 'device_id'
require_relative 'yaml_record'

module RubyHome
  class AccessoryInfo < YamlRecord::Base
    properties :device_id, :paired_clients, :password, :signature_key, :username
    source 'accessory_info.yml'

    def self.instance
      first || create(
        device_id: DeviceID.generate,
        paired_clients: [],
        password: '031-45-154',
        signature_key: RbNaCl::Signatures::Ed25519::SigningKey.generate.to_bytes.unpack1('H*'),
        username: 'Pair-Setup'
      )
    end

    def add_paired_client(admin: false, identifier: , public_key: )
      paired_clients << { admin: admin, identifier: identifier, public_key: public_key }
      save
    end

    def remove_paired_client(identifier)
      paired_clients.delete_if { |h| h[:identifier] == identifier }
      save
    end

    def paired?
      paired_clients.any?
    end

    def signing_key
      @signing_key ||= RbNaCl::Signatures::Ed25519::SigningKey.new([signature_key].pack('H*'))
    end
  end
end
