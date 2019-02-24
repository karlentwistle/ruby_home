require_relative 'persistable'

module RubyHome
  class AccessoryInfo
    include Persistable

    self.source = 'accessory_info.yml'

    def self.instance
      @@_instance ||= persisted || create
    end

    def self.reload
      @@_instance = nil
    end

    USERNAME = -'Pair-Setup'
    DEFAULT_MODEL_NAME = -'RubyHome'

    def initialize(device_id: nil, model_name: nil, paired_clients: [], password: nil, signature_key: nil)
      @device_id = device_id
      @model_name = model_name
      @paired_clients = paired_clients
      @password = password
      @signature_key = signature_key
    end

    def username
      USERNAME
    end

    def password
      @password ||= Password.generate
    end

    def device_id
      @device_id ||= DeviceID.generate
    end

    def model_name
      @model_name ||= DEFAULT_MODEL_NAME
    end

    attr_writer :model_name

    def paired_clients
      @paired_clients ||= []
    end

    def add_paired_client(admin: false, identifier: , public_key: )
      @paired_clients << { admin: admin, identifier: identifier, public_key: public_key }
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

    private

      def signature_key
        @signature_key ||= RbNaCl::Signatures::Ed25519::SigningKey.generate.to_bytes.unpack1('H*')
      end

      def persisted_attributes
        {
          device_id: device_id,
          paired_clients: paired_clients,
          password: password,
          signature_key: signature_key
        }
      end
  end
end
