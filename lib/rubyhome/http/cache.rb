require 'singleton'

module Rubyhome
  module ActLikeHash
    def [](key)
      store[key]
    end

    def []=(key, value)
      store[key] = value
    end
  end

  class Cache
    include ActLikeHash

    def store
      @store ||= {}
    end
  end

  class GlobalCache
    include Singleton
    include ActLikeHash

    def store
      @@store ||= {}
    end
  end
end
