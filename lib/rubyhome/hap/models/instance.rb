require_relative 'application_record'

module Rubyhome
  class Instance < ApplicationRecord
    belongs_to :attributable, polymorphic: true
  end
end
