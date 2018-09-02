module RubyHome
  module Password
    class << self
      DELIMITER = '-'
      LENGTH = 8
      INVALIDS = [
        '00000000',
        '11111111',
        '22222222',
        '33333333',
        '44444444',
        '55555555',
        '66666666',
        '77777777',
        '88888888',
        '99999999',
        '12345678',
        '87654321',
      ]

      # The Setup Code must conform to the format XXX-XX-XXX where each X is a
      # 0-9 digit and dashes are required. For example, "101-48-005" (without
      # quotes). The accessory must generate its SRP verifier with the full
      # Setup Code, including dashes.

      def generate
        loop do
          digits = random_digits(LENGTH)
          break format(digits.to_s) unless INVALIDS.include?(digits)
        end
      end

      def format(digits)
        [
          digits[0...3],
          digits[3...5],
          digits[5...8],
        ].join(DELIMITER)
      end

      def random_digits(length)
        Array.new(length) { rand(0..9) }.join
      end
    end
  end
end
