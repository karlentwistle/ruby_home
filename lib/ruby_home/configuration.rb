module RubyHome
  class Configuration
    extend Forwardable

    def initialize(accessory_info = AccessoryInfo.instance)
      @accessory_info = accessory_info
    end

    def_delegators :@accessory_info, :model_name, :model_name=
    def_delegators :@accessory_info, :password, :password=
  end
end
