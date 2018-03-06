require_relative 'application_record'

module Rubyhome
  class Accessory < ApplicationRecord

    has_many :services
    has_many :characteristics, through: :services

    def next_available_instance_id
      (largest_instance_id || 0) + 1
    end

    def instance_ids
      services.pluck(:instance_id) + characteristics.pluck(:instance_id)
    end

    def largest_instance_id
      instance_ids.max
    end
  end
end
