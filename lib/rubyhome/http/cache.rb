require "singleton"

module Rubyhome
  class Cache
    include Singleton

    attr_reader :store
    
    def initialize
      @store = {}
    end

    def [](key)
      instance.store[key]
    end

    def []=(key, value)
      instance.store[key] = value
    end
  end
end
