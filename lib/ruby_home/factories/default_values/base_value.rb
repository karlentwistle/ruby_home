module RubyHome
  class BaseValue
    def initialize(template)
      @template = template
    end

    def default
      raise NotImplementedError
    end

    private

      attr_reader :template
  end
end
