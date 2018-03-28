# This is an automatically generated file, please do not modify

module Rubyhome
  class Service
    class Outlet < Service
      class << self
        def uuid
          "00000047-0000-1000-8000-0026BB765291"
        end

        def name
          :outlet
        end

        def required_characteristic_uuids
          ["00000025-0000-1000-8000-0026BB765291", "00000026-0000-1000-8000-0026BB765291"]
        end

        def optional_characteristic_uuids
          ["00000023-0000-1000-8000-0026BB765291"]
        end
      end

      def name
        "Outlet"
      end
    end
  end
end
