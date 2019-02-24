module RubyHome
  class Configuration
    extend Forwardable

    def initialize(accessory_info = AccessoryInfo.instance)
      @accessory_info = accessory_info
    end

    DEFAULT_PORT = 4567

    def port
      @port || DEFAULT_PORT
    end

    attr_writer :port

    def_delegators :@accessory_info, :model_name, :model_name=
    def_delegators :@accessory_info, :password, :password=
  end
end
