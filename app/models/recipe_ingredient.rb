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
      'sheet',
      'pint',
      'dash',
      'half',
      'stick',
      'chip',
      'loaf',
      'drop',
      'flake',
      'bottle',
      'piece',
      'jar',
      'ear',
      'bunch'
  ]
  .map {|c| "#{c}|#{c.pluralize}" }
  .freeze

  QUALIFIER_TOKENS = [
    'freshly',
    'ground',
    'extra(\s|\-)?lean',
    'low(\s|\-)?sodium',
    'lean',
    'all-purpose',
    'shredded',
    'cooked',
    'boneless',
    'skinless',
    'minced',
    'grated',
    'chopped',
    'refrigerated',
    'warm',
    'to taste',
    'classic',
    'crushed',
    'coarse(ly)?',
    'large',
    'packed',
    'mild',
    'flaked',
    'fully',
    'mashed',
    'firmly'
  ]

end
