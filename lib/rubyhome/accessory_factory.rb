require_relative 'hap/service'

module Rubyhome
  module AccessoryBuilder
    class << self
      def build
        Service.descendants.each do |class_name|
          create_factory_class(class_name)
        end
      end

      def create_factory_class(class_name)
        klass = Class.new do
        end

        klass = Rubyhome.const_set(factory_name(class_name), klass)
      end

      def factory_name(class_name)
        demodulize(class_name) + "Factory"
      end

      def demodulize(path)
        path = path.to_s
        if i = path.rindex("::")
          path[(i + 2)..-1]
        else
          path
        end
      end
    end
  end

  AccessoryBuilder.build
end
