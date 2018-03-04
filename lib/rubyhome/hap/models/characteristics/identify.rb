module Rubyhome
  class Characteristic
    class Identify < Characteristic
      def description
        'Identify'
      end

      def format
        'bool'
      end

      def permissions
        ['pw']
      end

      def uuid
        '00000014-0000-1000-8000-0026BB765291'
      end
    end
  end
end
