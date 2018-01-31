require 'singleton'

module Rubyhome
  class Cache
    include Singleton

    def store
      @@store ||= {}
    end

    def [](key)
      store[key]
    end

    def []=(key, value)
      store[key] = value
    end
  end
end
