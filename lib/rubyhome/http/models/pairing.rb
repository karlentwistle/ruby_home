class Pairing < ActiveRecord::Base
  validates :identifier, presence: true
  validates :public_key, presence: true
  validates :admin, presence: true, inclusion: { in: [ true, false ] }
end
