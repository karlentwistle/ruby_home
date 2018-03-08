require_relative 'application_record'

module Rubyhome
  class Service < ApplicationRecord
    validates :type, presence: true

    belongs_to :accessory, required: true
    has_many :characteristics

    before_save :set_instance_id

    private

      def set_instance_id
        self.instance_id ||= accessory.next_available_instance_id
      end
  end
end

Dir[File.dirname(__FILE__) + '/services/*.rb'].each { |file| require file }
