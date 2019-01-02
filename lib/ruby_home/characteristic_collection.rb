module RubyHome
  class CharacteristicCollection
    include Enumerable

    def initialize(*characteristics)
      @characteristics = characteristics
    end

    def each(&block)
      characteristics.each(&block)
    end

    def <<(characteristic)
      define_service_getter(characteristic)
      define_service_setter(characteristic)

      @characteristics << characteristic
    end

    alias all to_a

    def contains_instance_id?(instance_id)
      map(&:instance_id).include?(instance_id)
    end

    private

      attr_reader :characteristics

      def define_service_getter(characteristic)
        service = characteristic.service

        unless service.respond_to?(characteristic.name)
          service.define_singleton_method(characteristic.name) { characteristic }
        end
      end

      def define_service_setter(characteristic)
        service = characteristic.service

        unless service.respond_to?("#{characteristic.name}=")
          service.define_singleton_method("#{characteristic.name}=") do |args|
            characteristic.value = args
          end
        end
      end
  end
end
