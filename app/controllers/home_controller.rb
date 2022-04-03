class HomeController < ApplicationController

    def index
        @default_ingredients = Ingredient.autocomplete
    end
end
