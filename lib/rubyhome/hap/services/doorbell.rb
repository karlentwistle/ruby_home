# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class Doorbell < Service
      class << self
        def uuid
          "00000121-0000-1000-8000-0026BB765291"
        end

        def required_characteristic_uuids
          ["00000073-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["00000008-0000-1000-8000-0026BB765291", "00000119-0000-1000-8000-0026BB765291", "00000023-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Doorbell"
      end
    end
  end
end
