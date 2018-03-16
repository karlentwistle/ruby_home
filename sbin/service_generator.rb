#!/usr/bin/env ruby

require 'byebug'
require 'plist'

module Rubyhome
  class ServiceGenerator
    class << self
      def run
        convert_binary_plist
        parsed_xml['Services'].each do |services_xml|
          new(services_xml).generate_characteristic_class
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
      @name = xml["Name"]
      @optional_characteristics = xml["OptionalCharacteristics"]
      @required_characteristics = xml["RequiredCharacteristics"]
      @uuid = xml["UUID"]
    end

    def generate_characteristic_class
      create_file
    end

    private

      def create_file
        f = File.open(file_path, 'w')
        f.write generate_class
        f.close
      end

      def generate_class
        <<~KLASS
          # This is an automatically generated file, please do not modify

          module Rubyhome
            class Service
              class #{class_name} < Service
                class << self
                  def uuid
                    "#{uuid}"
                  end

                  def required_characteristic_uuids
                    #{required_characteristics}
                  end

                  def optional_characteristic_uuids
                    #{optional_characteristics}
                  end
                end

                def name
                  "#{name}"
                end
              end
            end
          end
        KLASS
      end

      def file_path
        File.dirname(__FILE__) + '/../lib/rubyhome/hap/services/' + sanitized_name + '.rb'
      end

      def sanitized_name
        name.downcase.gsub(' ', '_')
      end

      def class_name
        name.gsub(' ', '')
      end

      private

      attr_reader :name, :optional_characteristics, :required_characteristics, :uuid
  end
end

Rubyhome::ServiceGenerator.run
