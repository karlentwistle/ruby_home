# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class Lightbulb < Service
      class << self
        def uuid
          "00000043-0000-1000-8000-0026BB765291"
        end

        def required_characteristic_uuids
          ["00000025-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["00000008-0000-1000-8000-0026BB765291", "00000013-0000-1000-8000-0026BB765291", "0000002F-0000-1000-8000-0026BB765291", "00000023-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Lightbulb"
      end
    end
  end
end
