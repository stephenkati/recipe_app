class Food < ApplicationRecord
  belongs_to :user

  # Validations
  validates :name, presence: true, length: { max: 250 }
  validates :measurement_unit, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
end
