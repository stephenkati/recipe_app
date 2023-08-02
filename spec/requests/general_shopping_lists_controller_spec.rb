require 'rails_helper'

RSpec.describe GeneralShoppingListsController, type: :request do
  let(:user) { User.new(name: 'test', email: 'test@test.com', password: 'password') }
  let(:recipe) do
    Recipe.new(name: 'recipe', preparation_time: 10, cooking_time: 20, description: 'my recipe', public: false,
               user_id: user.id)
  end
  let(:food) { Food.new(name: 'food', measurement_unit: 'units', price: 10, quantity: 10, user_id: user.id) }

  before do
    user.skip_confirmation!
    user.save
    recipe.save
    food.save
  end

  def authenticate_user(user)
    post user_session_path, params: { user: { email: user.email, password: user.password, name: user.name } }
    follow_redirect!
  end

  describe 'GET #index' do
    let(:general_shopping_list) { [{ food_id: food.id, name: food.name, price: food.price, quantity: food.quantity }] }

    it 'returns a success response if user is authenticated' do
      authenticate_user(user)
      get general_shopping_lists_path

      expect(response).to have_http_status(:ok)
      expect(assigns(:user)).to eq(user)
      expect(assigns(:general_shopping_list)).to eq(general_shopping_list)
      expect(assigns(:total_food_items)).to eq(food.quantity)
      expect(assigns(:total_price)).to eq(food.price * food.quantity)
    end
  end
end
