class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[ show edit update destroy ]

  # GET /recipes or /recipes.json
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/1 or /recipes/1.json
  def show
  end

  def search
    @ingredient_ids = params[:ingredient_ids]
    @recipes = Recipe.includes(:recipe_ingredients)
    .includes(*Recipe::TAG_CONTEXTS.map { |t| "#{t}_tag"})
    .limit(30)
    .where(recipe_ingredients: { ingredient_id: @ingredient_ids })
    #  (@ingredient_ids.blank? ? Recipe.all : Recipe.joins(ActiveRecord::Base.send(:sanitize_sql_array, [%Q(
    #   LEFT OUTER JOIN recipe_ingredients i
    #     ON i.recipe_id = recipes.id
    #     AND i.ingredient_id in (?)
    # ), @ingredient_ids]) )).yield_self do |recipes|
      # Recipe.includes(:recipe_ingredients)
      #   .includes(*Recipe::TAG_CONTEXTS.map { |t| "#{t}_tag"})
      #   .limit(30)
      #   .where(recipe_ingredients: { ingredient_id: @ingredient_ids })
    # end
    respond_to do |format|
      format.json { render :index }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.fetch(:recipe, {})
    end
end
