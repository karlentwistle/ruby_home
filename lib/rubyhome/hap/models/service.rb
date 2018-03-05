require_relative 'application_record'
require_relative 'instance'

module Rubyhome
  class Service < ApplicationRecord
    def self.grouped_by_accessory
      all.group_by(&:accessory_id)
    end

    validates :type, presence: true

    has_many :characteristics
    has_one :instance, as: :attributable, required: true

    def instance
      super || build_instance
    end

    def iid
      instance.id
    end

    before_create :build_associations

    private

      def build_associations
        instance
      end
  end
end

Dir[File.dirname(__FILE__) + '/services/*.rb'].each { |file| require file }
