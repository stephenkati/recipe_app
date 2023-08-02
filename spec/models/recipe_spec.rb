require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'associations' do
    it 'should have many foods' do
      expect(Recipe.reflect_on_association(:foods).macro).to eq(:has_many)
    end

    it 'should have many recipe_foods' do
      expect(Recipe.reflect_on_association(:recipe_foods).macro).to eq(:has_many)
    end

    it 'should belong to a user' do
      expect(Recipe.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    let(:user) { User.create(name: 'test', email: 'test@test.com', password: 'password') }

    let(:recipe) do
      Recipe.create(name: 'recipe', preparation_time: 10, cooking_time: 20, description: 'my recipe', public: false,
                    user_id: user.id)
    end

    it 'is valid with valid attributes' do
      expect(recipe).to be_valid
    end

    it 'should validate presence of name' do
      recipe.name = nil
      expect(recipe).not_to be_valid
    end

    it 'should validate presence of preparation_time' do
      recipe.preparation_time = nil
      expect(recipe).not_to be_valid
    end

    it 'should validate presence of cooking_time' do
      recipe.cooking_time = nil
      expect(recipe).not_to be_valid
    end

    it 'should validate presence of description' do
      recipe.description = nil
      expect(recipe).not_to be_valid
    end

    it 'should validate presence of user_id' do
      recipe.user_id = nil
      expect(recipe).not_to be_valid
    end
  end
end
