module Rubyhome
  class Characteristic
    class Manufacturer < Characteristic
      validates :value, presence: true

      def description
        'Manufacturer'
      end

      def format
        'string'
      end

      def permissions
        ['pr']
      end

      def uuid
        '00000020-0000-1000-8000-0026BB765291'
      end
    end
  end
end
