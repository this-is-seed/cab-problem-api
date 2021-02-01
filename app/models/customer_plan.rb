class CustomerPlan < ApplicationRecord

  # associations
  has_many :customer

  # validations
  validates :code, uniqueness: true

end
