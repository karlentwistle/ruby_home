require_relative '../characteristic'

module Rubyhome
  class Characteristic
    class Name < Characteristic
      def description
        'Name'
      end

      def format
        'string'
      end

      def permissions
        ['pr']
      end

      def uuid
        '00000023-0000-1000-8000-0026BB765291'
      end
    end
  end
end
