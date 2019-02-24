module RubyHome
  class Configuration
    extend Forwardable

    def initialize(accessory_info = AccessoryInfo.instance)
      @accessory_info = accessory_info
    end

    DEFAULT_BIND = -'0.0.0.0'
    DEFAULT_PORT = 4567

    def port
      @port || DEFAULT_PORT
    end

    def bind
      @bind || DEFAULT_BIND
    end

    attr_writer :bind, :port

    def_delegators :@accessory_info, :model_name, :model_name=
    def_delegators :@accessory_info, :password, :password=
  end
end
