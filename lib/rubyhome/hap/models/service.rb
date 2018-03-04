require_relative 'application_record'

module Rubyhome
  class Service < ApplicationRecord
    validates :type, presence: true

    has_many :characteristics
  end
end

Dir[File.dirname(__FILE__) + '/services/*.rb'].each { |file| require file }
