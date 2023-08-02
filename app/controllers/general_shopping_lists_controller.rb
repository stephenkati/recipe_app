class GeneralShoppingListsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  def index
    @user = current_user
    @general_shopping_list = generate_general_shopping_list
    @total_food_items = @general_shopping_list.sum { |item| item[:quantity] }
    @total_price = @general_shopping_list.sum { |item| item[:price] * item[:quantity] }
  end

  private

  def generate_general_shopping_list
    unused_foods = current_user.foods.where.not(id: current_user.recipes.joins(:foods).distinct.pluck('foods.id'))

    unused_foods.map do |food|
      { food_id: food.id, name: food.name, price: food.price, quantity: food.quantity }
    end
  end
end
