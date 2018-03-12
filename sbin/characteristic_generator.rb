#!/usr/bin/env ruby

require 'byebug'
require 'plist'

module Rubyhome
  class CharacteristicGenerator
    class << self
      def run
        convert_binary_plist
        parsed_xml['Characteristics'].each do |characteristics_xml|
          new(characteristics_xml).generate_characteristic_class
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

    def generate_characteristic_class
      create_file

    end

    def create_file
      f = File.open(file_path, "w")
      f.close
    end

    def file_path
      File.dirname(__FILE__) + '../lib/rubyhome/hap/characteristics/' + sanitized_name + '.rb'
    end

    def sanitized_name
      name.downcase.gsub(' ', '_')
    end

    private

    attr_reader :constraints, :format, :name, :permissions, :properties, :uuid, :unit
  end
end

Rubyhome::CharacteristicGenerator.run
