#!/usr/bin/env ruby

require 'byebug'
require 'plist'
require 'yaml'

module RubyHome
  class ServiceGenerator
    class << self
      def run
        convert_binary_plist
        File.open(file_path, 'w') do |file|
          file.write generate_services.to_yaml
        end
      end

      def generate_services
        parsed_xml['Services'].map do |services_xml|
          new(services_xml).generate_service_hash
        end
      end

      def convert_binary_plist
        system([
          'plutil -convert xml1 -o',
          '/tmp/Accessory.xml',
          "\'/Applications/Utilities/HomeKit\ Accessory\ Simulator.app/Contents/Frameworks/HAPAccessoryKit.framework/Versions/A/Resources/default.metadata.plist\'"
        ].join(' '))
      end

      def parsed_xml
        Plist.parse_xml('/tmp/Accessory.xml')
      end

      def file_path
        File.dirname(__FILE__) + '/../lib/ruby_home/config/services.yml'
      end
    end

    def initialize(xml)
      @name = xml["Name"]
      @optional_characteristics = xml["OptionalCharacteristics"]
      @required_characteristics = xml["RequiredCharacteristics"]
      @uuid = xml["UUID"]
    end

    def generate_service_hash
      {
        name: sanitized_name.to_sym,
        description: name,
        uuid: uuid,
        optional_characteristics_uuids: optional_characteristics,
        required_characteristics_uuids: required_characteristics,
      }
    end

    private

      def sanitized_name
        name.downcase.gsub(' ', '_')
      end

      COLOR_TEMPERATURE_UUID = -'000000CE-0000-1000-8000-0026BB765291'

      def optional_characteristics
        if sanitized_name == 'lightbulb'
          # HomeKit Accessory Simulator doesnt include color temperature as a characteristic
          # HAP-Specification-Non-Commercial-Version lists it as a valid optional characteristic
          @optional_characteristics + [COLOR_TEMPERATURE_UUID]
        else
          @optional_characteristics
        end
      end

      attr_reader :name, :required_characteristics, :uuid
  end
end

RubyHome::ServiceGenerator.run
