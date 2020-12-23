module RubyHome
  module SetupID
    class << self
      # Requirements for Setup ID of the accessory are not completely clear.
      # A unique random string of letters, generated at every
      # factory reset and persisted across reboots seems fine.

      def generate(count=4)
        id = ''
        count.times {
          id << random_letter
        }
        id
      end

      def random_letter
        ('A'..'Z').to_a[rand(26)]
      end
    end
  end
end
