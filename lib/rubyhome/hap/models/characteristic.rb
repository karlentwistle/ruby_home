require_relative 'application_record'
require_relative 'instance'

module Rubyhome
  class Characteristic < ApplicationRecord
    validates :type, presence: true

    belongs_to :service, required: true
    has_one :instance, as: :attributable, required: true

    def instance
      super || build_instance
    end

    def iid
      instance.id
    end

    def aid
      service.accessory_id
    end

    before_create :build_associations

    private

      def build_associations
        instance
      end
  end
end

Dir[File.dirname(__FILE__) + '/characteristics/*.rb'].each { |file| require file }
