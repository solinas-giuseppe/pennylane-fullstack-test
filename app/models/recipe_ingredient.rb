class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  after_initialize :expand_attributes
  AMOUNT_TOKENS = [
      'cup',
      'teaspoon',
      'tablespoon',
      'package',
      'can',
      'quart',
      'gram',
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
      {**t, unit: t['unit'].singularize}
    end
  end

  def expand_attributes
    return if full_definition.blank?
    auto_attrs = RecipeIngredient.parse_definition(full_definition)
    ingredient_name = auto_attrs.delete("name")
    self.ingredient = Ingredient.new({name: ingredient_name}) if ingredient_name.present?
    assign_attributes(auto_attrs)
  end
end
