module RubyHome
  class Configuration
    extend Forwardable

    def initialize(accessory_info = AccessoryInfo.instance)
      @accessory_info = accessory_info
    end

    def_delegators :@accessory_info, :model_name, :model_name=
  end
end
