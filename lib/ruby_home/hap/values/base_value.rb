require "facets/string/modulize"

module RubyHome
  class BaseValue
    def self.value_for_template(template)
      return IdentifyValue if template.name == :identify

      Object.const_get("::RubyHome::#{template.format.modulize}Value") || NullValue
    end

    def initialize(characteristic_template = nil, initial_value = nil)
      @template = characteristic_template
      @value = initial_value
    end

    def value
      @value || default
    end

    def default
      raise NotImplementedError
    end

    attr_writer :value

    private

    attr_reader :template
  end
end
