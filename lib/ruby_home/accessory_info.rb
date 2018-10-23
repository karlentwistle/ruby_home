module RubyHome
  class AccessoryInfo
    def self.instance
      persisted || create
    end

    def self.persisted
      new(self.read) if self.read
    end

    def self.create
      new.save
    end

    def self.source(file=nil)
      file ? @file = (file.to_s) : @file
    end

    def self.write(collection)
      File.open(self.source, 'w') {|f| f.write(collection.to_yaml) }
    end

    def self.read
      return false unless File.exists?(source)

      YAML.load_file(self.source)
    end

    source 'accessory_info.yml'

    USERNAME = -'Pair-Setup'

    def initialize(device_id: nil, paired_clients: [], password: nil, signature_key: nil)
      @device_id = device_id
      @paired_clients = paired_clients
      @password = password
      @signature_key = signature_key
    end

    def save
      self.class.write(persisted_attributes)
      self
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
