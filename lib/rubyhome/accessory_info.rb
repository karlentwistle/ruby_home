require 'ed25519'
require 'yaml/store'
require_relative 'device_id'

module Rubyhome
  class AccessoryInfo
    PERSISTABLE = [ :device_id, :paired_clients, :password, :signature_key, :username ].freeze

    def initialize(store)
      @store = store

      read

      @device_id ||= DeviceID.generate
      @paired_clients ||= []
      @signature_key ||= Ed25519::SigningKey.generate.to_bytes.unpack1('H*')
    end

    attr_reader :store
    attr_reader :device_id, :signature_key, :paired_clients, :password, :username
    attr_writer :device_id, :paired_clients, :password, :username

    def signature_key=(signature_key)
      @signing_key = nil
      @signature_key = signature_key
    end

    def signing_key
      @signing_key ||= Ed25519::SigningKey.new([signature_key].pack('H*'))
    end

    def username
      'Pair-Setup'
    end

    def password
      '031-45-154'
    end

    def to_hash
      Hash[*PERSISTABLE.flat_map { |attribute| [attribute, send(attribute)] }]
    end

    def read
      store.transaction(true) do
        store.fetch(:accessory_info, {}).each do |key, value|
          send("#{key}=", value)
        end
      end
    end

    def save
      store.transaction do
        store[:accessory_info] = to_hash
      end
    end

    def self.pstore=(new_storage)
      @@accessory_info = AccessoryInfo.new(new_storage)
    end

    @@accessory_info = AccessoryInfo.new(YAML::Store.new 'config.yml')

    class << self
      PERSISTABLE.each do |attribute|
        define_method("#{attribute}=") do |value, save=true|
          @@accessory_info.send("#{attribute}=", value)
          save
        end

        define_method(attribute) do
          @@accessory_info.send(attribute)
        end
      end

      def save
        @@accessory_info.save
      end

      def signing_key
        @@accessory_info.signing_key
      end

      def paired?
        @@accessory_info.paired_clients.any?
      end

      def add_paired_client(hash)
        @@accessory_info.paired_clients << hash
        save
      end

      def remove_paired_client(identifier)
        @@accessory_info.paired_clients.delete_if { |h| h[:identifier] == identifier }
        save
      end
    end
  end
end
