require_relative '../characteristic'

module Rubyhome
  class Characteristic
    class On < Characteristic
      def description
        'On'
      end

      def format
        'bool'
      end

      def permissions
        ['pr', 'pw', 'ev']
      end

      def value
        false
      end

      def uuid
        '00000025-0000-1000-8000-0026BB765291'
      end
    end
  end
end
