require_relative 'rubyhome/version'
require_relative 'rubyhome/broadcast'
Dir[File.dirname(__FILE__) + '/rubyhome/hap/builders/*.rb'].each { |file| require file }

module Rubyhome
end
