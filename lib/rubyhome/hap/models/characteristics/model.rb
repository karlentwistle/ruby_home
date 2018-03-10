require_relative '../characteristic'

module Rubyhome
  class Characteristic
    class Model < Characteristic
      def description
        'Model'
      end

      def format
        'string'
      end

      def permissions
        ['pr']
      end

      def uuid
        '00000021-0000-1000-8000-0026BB765291'
      end
    end
  end
end
