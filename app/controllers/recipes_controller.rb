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
    @ingredient_ids = params[:ingredient_ids].to_a
    @recipe_ids = Recipe.joins(@ingredient_ids.length == 0 ? '' : @ingredient_ids.map do |id|
      table_alias = SecureRandom.uuid
      ActiveRecord::Base.send(:sanitize_sql_array, [%Q(
        INNER JOIN recipe_ingredients t_#{id} ON t_#{id}.ingredient_id = ? AND t_#{id}.recipe_id = recipes.id
      ), id])
    end).limit(25).pluck(:id)
    @recipes = Recipe.includes(:recipe_ingredients)
        .includes(*Recipe::TAG_CONTEXTS.map { |t| "#{t}_tag"})
        .where(id: @recipe_ids)

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
