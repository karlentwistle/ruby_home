module RubyHome
  class Configuration
    extend Forwardable

    def initialize(accessory_info = AccessoryInfo.instance)
      @accessory_info = accessory_info
    end

    DEFAULT_BIND = -'0.0.0.0'
    DEFAULT_PORT = 4567
    DEFAULT_MODEL_NAME = -'RubyHome'

    def model_name
      @model_name || DEFAULT_MODEL_NAME
    end

    def port
      @port || DEFAULT_PORT
    end

    def bind
      @bind || DEFAULT_BIND
    end

    attr_writer :model_name, :bind, :port

    def_delegators :@accessory_info, :password, :password=
  end
end
