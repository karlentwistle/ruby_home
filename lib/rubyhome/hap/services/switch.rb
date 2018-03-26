# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class Switch < Service
      class << self
        def uuid
          "00000049-0000-1000-8000-0026BB765291"
        end

        def name
          :switch
        end

        def required_characteristic_uuids
          ["00000025-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["00000023-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Switch"
      end
    end
  end
end
