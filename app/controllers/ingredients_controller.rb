class IngredientsController < ApplicationController

    def autocomplete
        respond_to do |format|
            @ingredients = Ingredient.autocomplete(params[:search].presence)
            format.json { render json: @ingredients.to_json }
        end
    end
end
