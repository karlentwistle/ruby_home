# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class GarageDoorOpener < Service
      class << self
        def uuid
          "00000041-0000-1000-8000-0026BB765291"
        end

        def name
          :garage_door_opener
        end

        def required_characteristic_uuids
          ["0000000E-0000-1000-8000-0026BB765291", "00000032-0000-1000-8000-0026BB765291", "00000024-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["0000001D-0000-1000-8000-0026BB765291", "0000001E-0000-1000-8000-0026BB765291", "00000023-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Garage Door Opener"
      end
    end
  end
end
