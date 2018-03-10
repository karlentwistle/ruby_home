require 'singleton'
require 'ed25519'
require_relative 'device_id'

module Rubyhome
  class AccessoryInfo
    include Singleton

    def device_id
      @device_id ||= DeviceID.generate
    end

    attr_writer :device_id

    def username
      'Pair-Setup'
    end

    def password
      '031-45-154'
    end

    def signing_key
      @signing_key ||= Ed25519::SigningKey.generate
    end

    attr_writer :signing_key

    def paired_clients
      @_paired_clients ||= []
    end

    def paired?
      paired_clients.any?
    end

    def remove_paired_clients!
      @_paired_clients = []
    end

    def remove_paired_client(identifier)
      paired_clients.delete_if { |h| h[:identifier] == identifier }
    end
  end
end
