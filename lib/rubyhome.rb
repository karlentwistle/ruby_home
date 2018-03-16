require_relative 'rubyhome/version'
require_relative 'rubyhome/broadcast'
require_relative 'rubyhome/identifier_cache'
require_relative 'rubyhome/accessory_information_factory'
require_relative 'rubyhome/fan_factory'

Dir[File.dirname(__FILE__) + '/rubyhome/hap/builders/*.rb'].each { |file| require file }

module Rubyhome; end
