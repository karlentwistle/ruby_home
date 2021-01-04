module RubyHome

  class UnknownCategoriyIdentifierError < StandardError; end

  class Configuration
    extend Forwardable

    CATEGORIES_FILEPATH = (File.dirname(__FILE__) + '/config/categories.yml').freeze
    CATEGORIES = YAML.load_file(CATEGORIES_FILEPATH).freeze

    def initialize(accessory_info = AccessoryInfo.instance)
      @accessory_info = accessory_info
    end

    DEFAULT_NAME = -'RubyHome'
    DEFAULT_HOST = -'0.0.0.0'
    DEFAULT_PORT = 4567
    DEFAULT_MODEL_NAME = DEFAULT_NAME
    DEFAULT_DISCOVERY_NAME = DEFAULT_NAME
    DEFAULT_CATEGORY_IDENTIFIER = 2

    def discovery_name
      @discovery_name || DEFAULT_DISCOVERY_NAME
    end

    def model_name
      @model_name || DEFAULT_MODEL_NAME
    end

    def port
      @port || DEFAULT_PORT
    end

    def host
      @host || DEFAULT_HOST
    end

    def category_identifier
      @category_identifier || DEFAULT_CATEGORY_IDENTIFIER
    end

    def category_identifier=(value)
      if value.is_a?(Symbol)
        raise UnknownCategoriyIdentifierError if !CATEGORIES.include?(value)
        @category_identifier = value
      else
        @category_identifier = value.to_i
      end
    end


    attr_writer :discovery_name, :model_name, :host, :port

    def_delegators :@accessory_info, :password, :password=
  end
end
