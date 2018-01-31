module Rubyhome
  class DeviceID
    class << self

      DELIMITER = ':'

      # Device ID of the accessory must be a unique random number generated at every
      # factory reset and must persist across reboots

      def generate(digits=12)
        random_hexadecimals(digits)
          .map(&:upcase)
          .each_slice(2)
          .map(&:join)
          .join(DELIMITER)
      end

      def random_hexadecimal
        rand(15).to_s(16)
      end

      def random_hexadecimals(digits=12)
        digits
          .times
          .map { random_hexadecimal }
      end

    end
  end
end
