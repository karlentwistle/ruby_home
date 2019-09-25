#!/usr/bin/env ruby

require 'byebug'
require 'plist'
require 'yaml'

module RubyHome
  class CharacteristicGenerator
    class << self
      def run
        convert_binary_plist
        File.open(file_path, 'w') do |file|
          file.write characteristics.to_yaml
        end
      end

      def characteristics
        generate_characteristics + hardcoded_characteristics
      end

      def generate_characteristics
        parsed_xml['Characteristics'].map do |characteristics_xml|
          new(characteristics_xml).generate_characteristic_hash
        end
      end

      def hardcoded_characteristics
        [
          # HomeKit Accessory Simulator doesnt include color temperature as a characteristic
          # HAP-Specification-Non-Commercial-Version lists it as a valid optional characteristic
          {
            name: :color_temperature,
            description: 'Color Temperature',
            uuid: '000000CE-0000-1000-8000-0026BB765291',
            format: 'uint32',
            unit: "nil",
            permissions: %w(securedRead securedWrite),
            properties: %w(read write cnotify),
            constraints: { 'MaximumValue': 400, 'MinimumValue': 50, 'StepValue': 1 }
          }
        ]
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
        File.dirname(__FILE__) + '/../lib/ruby_home/config/characteristics.yml'
      end
    end

    def initialize(xml)
      @constraints = xml["Constraints"]
      @format = xml["Format"]
      @name = xml["Name"]
      @permissions = xml["Permissions"]
      @properties = xml["Properties"]
      @uuid = xml["UUID"]
      @unit = xml["Unit"]
    end

    def generate_characteristic_hash
      {
        name: sanitized_name.to_sym,
        description: name,
        uuid: uuid,
        format: format,
        unit: sanitized_unit,
        permissions: permissions,
        properties: properties,
        constraints: constraints,
      }
    end

    private

      def sanitized_name
        name.downcase.gsub(' ', '_').gsub('.', '_')
      end

      def sanitized_unit
        if unit
          "\"#{unit}\""
        else
          "nil"
        end
      end

      private

      attr_reader :constraints, :format, :name, :permissions, :properties, :uuid, :unit
  end
end

RubyHome::CharacteristicGenerator.run
