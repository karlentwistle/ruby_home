Dir[File.dirname(__FILE__) + '/services/*.rb'].each { |file| require file }

module Rubyhome
  class Service
    def initialize(accessory: , primary: false, hidden: false)
      @accessory = accessory
      @primary = primary
      @hidden = hidden
      @characteristics = []
    end

    attr_reader :accessory, :characteristics, :primary, :hidden
    attr_accessor :instance_id
  end
end
