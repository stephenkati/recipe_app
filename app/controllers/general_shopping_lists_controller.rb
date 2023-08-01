class GeneralShoppingListsController < ApplicationController
  def index
    @user = current_user
    @recipes = @user.recipes.includes(recipe_foods: :food)
    @general_food_list = @user.foods
    @shopping_list = shopping_list
    @total_items = @shopping_list.size
    @total_price = total_price
  end

  private

  def shopping_list
    shopping_list_raw = build_shopping_list_raw

    shopping_list = []
    shopping_list_raw.each_value do |recipe_food|
      general_food = @general_food_list.find_by(name: recipe_food[:food].name)
      next unless general_food.nil? || general_food.quantity < recipe_food[:quantity]

      quantity = recipe_food[:quantity] - (general_food&.quantity || 0)
      shopping_list << {
        food: recipe_food[:food],
        quantity:,
        price: (general_food&.price || 0) * quantity
      }
    end

    shopping_list
  end

  def build_shopping_list_raw
    shopping_list_raw = {}

    @recipes.each do |recipe|
      recipe.recipe_foods.each do |recipe_food|
        food = recipe_food.food
        shopping_list_raw[food.id] ||= { food:, quantity: 0 }
        shopping_list_raw[food.id][:quantity] += recipe_food.quantity
      end
    end

    shopping_list_raw
  end

  def total_price
    @shopping_list.sum { |item| item[:price] }
  end
end
