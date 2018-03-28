# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class BatteryService < Service
      class << self
        def uuid
          "00000096-0000-1000-8000-0026BB765291"
        end

        def name
          :battery_service
        end

        def required_characteristic_uuids
          ["00000068-0000-1000-8000-0026BB765291", "0000008F-0000-1000-8000-0026BB765291", "00000079-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["00000023-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Battery Service"
      end
    end
  end
end
