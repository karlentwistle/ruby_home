require_relative '../characteristic'

module Rubyhome
  class Characteristic
    class FirmwareRevision < Characteristic
      def description
        'Firmware Revision'
      end

      def format
        'string'
      end

      def permissions
        ['pr']
      end

      def uuid
        '00000052-0000-1000-8000-0026BB765291'
      end
    end
  end
end
