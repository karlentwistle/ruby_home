require 'rqrcode'
module RubyHome
  module Greeter
    class << self
      def run
        unless paired?
          puts "Please enter this code with your HomeKit app on your iOS device to pair with RubyHome"
          puts "                       "
          puts "    ┌────────────┐     "
          puts "    │ " + pin + " │    "
          puts "    └────────────┘     "
          puts "                       "
          puts ascii_qrcode
        end
      end

      def pin
        accessory_info.password
      end

      def paired?
        accessory_info.paired?
      end

      def accessory_info
        AccessoryInfo.instance
      end

      def url
        record = RubyHome.dns_service.text_record
        category = record.accessory_category_identifier
        password = accessory_info.password
        setup_id = accessory_info.setup_id

        version = 0
        reserved = 0
        flags = record.feature_flags

        payload = 0
        payload |= (version & 0x7)

        payload <<= 4
        payload |= (reserved & 0xf)

        payload <<= 8
        payload |= (category & 0xff)

        payload <<= 4
        payload |= (flags & 0xf)

        payload <<= 27
        payload |= password.gsub('-', '').to_i(10) & 0x7fffffff

        "X-HM://#{payload.to_s(36).rjust(9, '0').upcase}#{setup_id.upcase}"
      end

      def ascii_qrcode
        qrcode = RQRCode::QRCode.new(url)
        terminal_qr = qrcode.to_s
        terminal_qr.gsub!(' ', '⬜')
        terminal_qr.gsub!('x', '⬛')
      end
    end
  end
end
