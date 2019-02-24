module RubyHome
  module DNS
    class Service
      def initialize(port)
        @port = port
      end

      def update
        dnssd_service.add_record(DNSSD::Record::TXT, text_record.encode)
      end

      def register
        dnssd_service
      end

      private

      def dnssd_service
        @_dnssd_service ||= begin
          DNSSD::Service.register(name, type, nil, port, nil, text_record)
        end
      end

      def name
        accessory_info.model_name
      end

      def type
        '_hap._tcp'
      end

      attr_reader :port

      def text_record
        TextRecord.new(accessory_info: accessory_info)
      end

      def accessory_info
        AccessoryInfo.instance
      end
    end
  end
end
