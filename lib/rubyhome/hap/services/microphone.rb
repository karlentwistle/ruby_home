# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class Microphone < Service
      class << self
        def uuid
          "00000112-0000-1000-8000-0026BB765291"
        end

        def name
          :microphone
        end

        def required_characteristic_uuids
          ["0000011A-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["00000119-0000-1000-8000-0026BB765291", "00000023-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Microphone"
      end
    end
  end
end
