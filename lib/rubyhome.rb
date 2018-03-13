require_relative 'rubyhome/version'
require_relative 'rubyhome/broadcast'
require_relative 'rubyhome/identifier_cache'
require_relative 'rubyhome/accessory_factory_generator'

Dir[File.dirname(__FILE__) + '/rubyhome/hap/builders/*.rb'].each { |file| require file }

module Rubyhome; end
