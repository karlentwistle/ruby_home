require 'webrick/httprequest'
require_relative '../counter'
require_relative '../hap/http_decryption'

module Rubyhome
  module HTTP
    class HAPRequest < WEBrick::HTTPRequest
      def parse(socket=nil)
        if decryption_time?
          request_line = socket.read_nonblock(@buffer_size)

          decrypted_request = decrypter.decrypt(request_line).join
          controller_to_accessory_count_increment(decrypter.count)

          super(StringIO.new(decrypted_request))
        else
          super(socket)
        end
      end

      private

      def decrypter
        @_decrypter ||= Rubyhome::HAP::HTTPDecryption.new(decryption_key, decrypter_params)
      end

      def decrypter_params
        {
          count: controller_to_accessory_count
        }
      end

      def decryption_time?
        !!decryption_key
      end

      def decryption_key
        cache[:controller_to_accessory_key]
      end

      def controller_to_accessory_count
        controller_to_accessory_counter.count
      end

      def controller_to_accessory_counter
        cache[:controller_to_accessory_count] ||= Rubyhome::Counter.new
      end

      def controller_to_accessory_count_increment(value)
        controller_to_accessory_counter.increment(value)
      end

      def cache
        Cache.instance
      end
    end
  end
end
