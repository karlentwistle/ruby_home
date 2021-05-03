require_relative "base_value"

module RubyHome
  class Uint32Value < BaseValue
    DEFAULT_VALUES = {
      color_temperature: 50,
      lock_management_auto_security_timeout: 0
    }.freeze

    def default
      DEFAULT_VALUES[name]
    end

    private

    def name
      template.name
    end
  end
end
