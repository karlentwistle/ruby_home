require_relative 'device_id'
require_relative 'yaml_record'

module RubyHome
  class AccessoryInfo < YamlRecord::Base
    USERNAME = -'Pair-Setup'

    properties :device_id, :paired_clients, :password, :signature_key
    source 'accessory_info.yml'

    set_callback :before_create, :set_device_id
    set_callback :before_create, :set_paired_clients
    set_callback :before_create, :set_password
    set_callback :before_create, :set_signature_key

    def self.instance
      first || create
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

    def username
      USERNAME
    end

    private

    def set_device_id
      self.device_id ||= DeviceID.generate
    end

    def set_paired_clients
      self.paired_clients = []
    end

    def set_password
      self.password ||= Password.generate
    end

    def set_signature_key
      self.signature_key ||= RbNaCl::Signatures::Ed25519::SigningKey.generate.to_bytes.unpack1('H*')
    end
  end
end
