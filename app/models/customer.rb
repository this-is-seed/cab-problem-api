class Customer < ApplicationRecord

  include Filterable

  # associations
  has_many :cab_trips
  belongs_to :customer_plan

  # validations
  validates :mobile_number, uniqueness: true
  validates :customer_plan_id, presence: true

  # filters
  scope :by_mobile_number, -> (by_mobile_number) {where(mobile_number: by_mobile_number)}
  scope :by_name, -> (by_name) {where("full_name like ?", "%#{by_name}%")}

end
