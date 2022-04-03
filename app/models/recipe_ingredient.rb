class RecipeIngredient < ApplicationRecord
  belongs_to :recipe, inverse_of: :recipe_ingredients, autosave: true
  belongs_to :ingredient, inverse_of: :recipe_ingredients, autosave: true
  after_initialize :expand_attributes
  AMOUNT_TOKENS = [
      'cup',
      'teaspoon',
      'tablespoon',
      'package',
      'can',
      'quart',
      'gram',
      'ounce',
      'pinch'
  ]
  .map {|c| "#{c}(?:s)?" }
  .freeze

  def self.get_def_regex
      digit_or_vular_fraction = "(?:(?:(?:[\u00BC-\u00BE\u2150-\u215E]|\d))\s*)*" # handles all the fraction chars as well as digits
      fractions = "[\u00BC-\u00BE\u2150-\u215E]"
      enclosed = "(?:\(.*?\))?"
      @@_def_regex = %r{
        (?<amount>\.?(?:(?:#{fractions}|\d+?)(?:\s+?)(?:\(.*?\))?)+)?
        (?:\s)?(?<unit>#{AMOUNT_TOKENS.join('|')})?
        (?:\s)?(?<name>[^\,|\r\n|(]*)
        (?:\,\s)?(?<variant>[^\,|\r\n]+)?
      }x
  end

  def self.parse_definition(definition)
    return {} if definition.blank?
    get_def_regex.match(definition).named_captures.yield_self do |t|
      {**t, unit: t['unit'].present? ? t['unit'].singularize : nil}
    end
  end

  private

  def expand_attributes
    return if full_definition.blank?
    auto_attrs = RecipeIngredient.parse_definition(full_definition)
    ingredient_name = auto_attrs.delete("name")
    self.ingredient = Ingredient.find_or_initialize_by({name: ingredient_name}) if ingredient_name.present?
    assign_attributes(auto_attrs)
  end
end
