# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class AccessoryInformation < Service
      class << self
        def uuid
          "0000003E-0000-1000-8000-0026BB765291"
        end

        def name
          :accessory_information
        end

        def required_characteristic_uuids
          ["00000014-0000-1000-8000-0026BB765291", "00000020-0000-1000-8000-0026BB765291", "00000021-0000-1000-8000-0026BB765291", "00000023-0000-1000-8000-0026BB765291", "00000030-0000-1000-8000-0026BB765291", "00000052-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["00000053-0000-1000-8000-0026BB765291", "000000A6-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Accessory Information"
      end
    end
  end
end
