require 'rails_helper'

RSpec.describe Food, type: :model do
  describe 'associations' do
    it 'should have many recipe_foods' do
      expect(Food.reflect_on_association(:recipe_foods).macro).to eq(:has_many)
    end
    it 'should have many recipes' do
      expect(Food.reflect_on_association(:recipes).macro).to eq(:has_many)
    end
    it 'should belong to a user' do
      expect(Food.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
  end
  describe 'validations' do
    let(:user) { User.create(name: 'test', email: 'test@test.com', password: 'password') }
    let(:food) { Food.create(name:'food', measurement_unit: 'unit', quantity: 10, price: 10, user_id: user.id) }
    it 'should be valid with attributes' do
      expect(food).to be_valid
    end
    it 'should not be valid without a name' do
      food.name = nil
      expect(food).not_to be_valid
    end
    it 'should not have a name longer than 250 characters' do
      food.name = 'a' * 251
      expect(food).not_to be_valid
    end
    it 'should not be valid without a measurement_unit' do
      food.measurement_unit = nil
      expect(food).not_to be_valid
    end
    it 'should not be valid without a quantity' do
      food.quantity = nil
      expect(food).not_to be_valid
    end
    it 'should not be valid without a price' do
      food.price = nil
      expect(food).not_to be_valid
    end
  end
end
