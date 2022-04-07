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
    @searches = params[:searches].to_a
    @recipe_ids = Recipe.joins(@searches.length == 0 ? '' : @searches.each_with_index.map do |search, i|
      %Q( INNER JOIN (#{Ingredient.search_name(search).select(:recipe_id).to_sql}) t_#{i} ON t_#{i}.recipe_id = recipes.id )
    end).limit(25).select(:id)
    @recipes = Recipe.includes(:ingredients)
        .includes(*Recipe::TAG_CONTEXTS.map { |t| "#{t}_tag"})
        .where(id: @recipe_ids)
        .page(params[:page])
        .per(25)

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
