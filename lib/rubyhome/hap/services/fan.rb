# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class Fan < Service
      class << self
        def uuid
          "00000040-0000-1000-8000-0026BB765291"
        end

        def required_characteristic_uuids
          ["00000025-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["00000028-0000-1000-8000-0026BB765291", "00000029-0000-1000-8000-0026BB765291", "00000023-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Fan"
      end
    end
  end
end
