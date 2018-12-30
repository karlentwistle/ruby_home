module RubyHome
  class ServiceCollection
    include Enumerable

    def initialize(*services)
      @services = services
    end

    def each
      services.map { |service| yield service }
    end

    def <<(service)
      @services << service
    end

    def characteristics
      flat_map(&:characteristics).flat_map(&:all)
    end

    private

      attr_reader :services
  end
end
