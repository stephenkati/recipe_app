class Food < ApplicationRecord
  belongs_to :user

  # Validations
  validate :name, presence: true, length: { max: 250}
  validate :measurement_unit, presence: true
  validate :price, presence: true
  validate :quantity, presence: true
end
