module RubyHome
  class Configuration
    extend Forwardable

    def initialize(accessory_info = AccessoryInfo.instance)
      @accessory_info = accessory_info
    end

    DEFAULT_NAME = -'RubyHome'
    DEFAULT_BIND = -'0.0.0.0'
    DEFAULT_PORT = 4567
    DEFAULT_MODEL_NAME = DEFAULT_NAME
    DEFAULT_DISCOVERY_NAME = DEFAULT_NAME

    def discovery_name
      @discovery_name || DEFAULT_DISCOVERY_NAME
    end

    def model_name
      @model_name || DEFAULT_MODEL_NAME
    end

    def port
      @port || DEFAULT_PORT
    end

    def bind
      @bind || DEFAULT_BIND
    end

    attr_writer :discovery_name, :model_name,:bind, :port

    def_delegators :@accessory_info, :password, :password=
  end
end
