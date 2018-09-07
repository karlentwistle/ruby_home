module RubyHome
  class CharacteristicFactory
    DEFAULT_VALUES = {
      identify: nil,
    }.freeze

    def self.create(characteristic_name, options={}, &block)
      new(characteristic_name, options).create(&block)
    end

    def initialize(characteristic_name, options)
      @characteristic_name = characteristic_name
      @options = options
    end

    def create
      yield characteristic if block_given?

      characteristic.save
      characteristic
    end

    private

      attr_reader :characteristic_name, :options

      def template
        @template ||= CharacteristicTemplate.find_by(name: characteristic_name.to_sym)
      end

      def characteristic
        @characteristic ||= Characteristic.new(characteristic_params)
      end

      def characteristic_params
        options[:value] ||= default_value
        options.merge(template.to_hash)
      end

      def default_value
        DEFAULT_VALUES.fetch(characteristic_name.to_sym) do
          klass = "RubyHome::#{template.format.classify}DefaultValue".safe_constantize || NullDefaultValue
          default_value = klass.new(template).default

          if default_value.nil?
            raise "No default value available for characteristic: #{characteristic_name} of type: #{template.format}"
          else
            default_value
          end
        end
      end
  end
end
