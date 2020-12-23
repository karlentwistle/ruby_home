module RubyHome
  module DNS
    class Service
      def initialize(configuration: )
        @configuration = configuration
      end

      def update
        return if RbConfig::CONFIG['target_os'] =~ /linux/

        dnssd_service.add_record(DNSSD::Record::TXT, text_record.encode)
      end

      def register
        dnssd_service
      end

      def text_record
        TextRecord.new(accessory_info: accessory_info, configuration: configuration)
      end

      private

      attr_reader :configuration

      def dnssd_service
        @_dnssd_service ||= begin
          DNSSD::Service.register(name, type, nil, port, host, text_record)
        end
      end

      def name
        configuration.discovery_name
      end

      def type
        -'_hap._tcp'
      end

      def port
        configuration.port
      end

      def host
        return nil if configuration.host == Configuration::DEFAULT_HOST

        configuration.host
      end

      def accessory_info
        AccessoryInfo.instance
      end
    end
  end
end
