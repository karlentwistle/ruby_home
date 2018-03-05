require_relative '../characteristic'

module Rubyhome
  class Characteristic
    class SerialNumber < Characteristic
      validates :value, presence: true

      def description
        'Serial Number'
      end

      def format
        'string'
      end

      def permissions
        ['pr']
      end

      def uuid
        '00000030-0000-1000-8000-0026BB765291'
      end
    end
  end
end
