#!/usr/bin/env ruby

require "byebug"
require "plist"
require "yaml"
require_relative "../lib/ruby_home"

module RubyHome
  class ServiceGenerator
    class << self
      def run
        convert_binary_plist
        File.open(file_path, "w") do |file|
          file.write generate_services.to_yaml
        end
      end

      def generate_services
        parsed_xml["Services"].map do |services_xml|
          new(services_xml).generate_service_hash
        end
      end

      def convert_binary_plist
        system([
          "plutil -convert xml1 -o",
          "/tmp/Accessory.xml",
          "\'/Applications/Utilities/HomeKit\ Accessory\ Simulator.app/Contents/Frameworks/HAPAccessoryKit.framework/Versions/A/Resources/default.metadata.plist\'"
        ].join(" "))
      end

      def parsed_xml
        Plist.parse_xml("/tmp/Accessory.xml")
      end

      def file_path
        File.dirname(__FILE__) + "/../lib/ruby_home/config/services.yml"
      end
    end

    def initialize(xml)
      @name = xml["Name"]
      @optional_characteristic_uuids = xml["OptionalCharacteristics"]
      @required_characteristic_uuids = xml["RequiredCharacteristics"]
      @uuid = xml["UUID"]
    end

    def generate_service_hash
      {
        name: sanitized_name.to_sym,
        description: name,
        uuid: uuid,
        optional_characteristic_names: optional_characteristic_names.sort,
        required_characteristic_names: required_characteristic_names.sort
      }
    end

    private

    def sanitized_name
      name.downcase.tr(" ", "_")
    end

    def optional_characteristic_names
      optional_characteristic_uuids.map do |uuid|
        RubyHome::CharacteristicTemplate.find_by(uuid: uuid).name
      end
    end

    def required_characteristic_names
      required_characteristic_uuids.map do |uuid|
        RubyHome::CharacteristicTemplate.find_by(uuid: uuid).name
      end + additional_required_characteristic_names
    end

    ADDITIONAL_REQUIRED_CHARACTERISTIC_NAMES = {
      "lightbulb" => [:color_temperature]
    }.freeze

    def additional_required_characteristic_names
      ADDITIONAL_REQUIRED_CHARACTERISTIC_NAMES.fetch(sanitized_name, [])
    end

    attr_reader :name, :required_characteristic_uuids, :optional_characteristic_uuids, :uuid
  end
end

RubyHome::ServiceGenerator.run
