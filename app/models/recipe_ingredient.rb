class RecipeIngredient < ApplicationRecord
  belongs_to :recipe, inverse_of: :recipe_ingredients, autosave: true
  belongs_to :ingredient, inverse_of: :recipe_ingredients, autosave: true
  AMOUNT_TOKENS = [
      'cup',
      'teaspoon',
      'tablespoon',
      'package',
      'can',
      'quart',
      'gram',
      'ounce',
      'pinch',
      'clove',
      'pound',
      'cube',
      'slice',
      'whole',
      'strip',
      'sheet'
  ]
  .map {|c| "#{c}(?:s)?" }
  .freeze

end
