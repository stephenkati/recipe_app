class RecipesController < ApplicationController
  before_action :authenticate_user!
  def index
    @recipes = Recipe.accessible_by(current_ability)
  end

  def public_recipes
    @recipes = Recipe.includes(:user, :foods).where(public: true).order(created_at: :desc)
  end

  def show
    @recipe = Recipe.find(params[:id])
    @user = current_user
    @recipe_foods = RecipeFood.includes(:recipe).where(recipe_id: @recipe.id)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user

    if @recipe.save
      flash[:notice] = 'Recipe saved successfully'
    else
      flash[:alert] = 'Failed to save Recipe!'
    end
    redirect_to recipes_path
  end

  def destroy
    @recipe = Recipe.find(params[:id])

    if @recipe.destroy
      flash[:notice] = 'Recipe deleted successfully.'
    else
      flash[:alert] = 'Error! Recipe not deleted.'
    end
    redirect_to recipes_path
  end

  def toggle_public
    @recipe = Recipe.find(params[:id])
    @recipe.update(public: !@recipe.public)
    redirect_to @recipe
  end

  def shopping_list
    @recipe = Recipe.find(params[:id])
    @shopping_list = generate_shopping_list_for_recipe(@recipe)
    @total_food_items = @shopping_list.sum { |item| item[:quantity] }
    @total_price = @shopping_list.sum { |item| item[:price] * item[:quantity] }
  end

  private

  def generate_shopping_list_for_recipe(recipe)
    ingredients = recipe.foods.select(:id, :name, :price).distinct
    shopping_list = []

    ingredients.each do |ingredient|
      total_quantity = recipe.recipe_foods.where(food: ingredient).sum(:quantity)
      shopping_list << { ingredient_name: ingredient.name,
                         quantity: total_quantity,
                         price: ingredient.price }
    end

    shopping_list
  end

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description)
  end
end
