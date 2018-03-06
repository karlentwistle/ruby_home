require_relative 'application_record'

module Rubyhome
  class Characteristic < ApplicationRecord
    validates :type, presence: true

    belongs_to :accessory, required: true
    belongs_to :service, required: true

    before_save :set_instance_id
    before_validation :inherit_accessory

    private

      def set_instance_id
        self.instance_id ||= accessory.next_available_instance_id
      end

      def inherit_accessory
        self.accessory ||= service.accessory
      end
  end
end

Dir[File.dirname(__FILE__) + '/characteristics/*.rb'].each { |file| require file }
