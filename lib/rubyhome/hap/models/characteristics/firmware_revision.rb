module Rubyhome
  class Characteristic
    class FirmwareRevision < Characteristic
      validates :value, presence: true

      def description
        'Firmware Revision'
      end

      def format
        'bool'
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
