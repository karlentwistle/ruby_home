module RubyHome
  class Configuration
    extend Forwardable

    def initialize(accessory_info = AccessoryInfo.instance)
      @accessory_info = accessory_info
    end

    DEFAULT_NAME = -'RubyHome'
    DEFAULT_HOST = -'0.0.0.0'
    DEFAULT_PORT = 4567
    DEFAULT_MODEL_NAME = DEFAULT_NAME
    DEFAULT_DISCOVERY_NAME = DEFAULT_NAME
    DEFAULT_CATEGORY_INDENTIFIER = 2

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
    
    def category_indentifier
      @category_indentifier || DEFAULT_CATEGORY_INDENTIFIER
    end

    
    attr_writer :discovery_name, :model_name, :host, :port, :category_indentifier 

    def_delegators :@accessory_info, :password, :password=
  end
end
