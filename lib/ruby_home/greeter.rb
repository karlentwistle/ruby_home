module RubyHome
  module Greeter
    class << self
      def run
        unless paired?
          puts "Please enter this code with your HomeKit app on your iOS device to pair with RubyHome"
          puts "                       "
          puts "    ┌────────────┐     "
          puts "    │ " + pin + " │    "
          puts "    └────────────┘     "
          puts "                       "
        end
      end

      def pin
        accessory_info.password
      end

      def paired?
        accessory_info.paired?
      end

      def accessory_info
        AccessoryInfo.instance
      end
    end
  end
end
