class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
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

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description)
  end
end
