require_relative 'application_record'

module Rubyhome
  class Characteristic < ApplicationRecord
    validates :type, presence: true
    validates :uuid, presence: true
  end
end

Dir[File.dirname(__FILE__) + '/characteristics/*.rb'].each { |file| require file }
