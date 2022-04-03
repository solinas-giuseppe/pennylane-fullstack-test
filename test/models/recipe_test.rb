require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  self.use_transactional_tests = true
  self.use_instantiated_fixtures = true
  setup do
    @ingredients_count = Ingredient.count
    @ingredient_strings = [
      "1 cup all-purpose flour",
      "1 cup yellow cornmeal",
      "⅔ cup white sugar",
      "1 teaspoon salt",
      "3 ½ teaspoons baking powder",
      "1 egg",
      "1 cup milk",
      "⅓ cup vegetable oil",
    ]
    @recipe = recipes(:one)
    puts "@recipe.ingredients.length #{@recipe.ingredients.length}"
  end

  test "it populates ingredients from a string array" do
    @recipe.assign_attributes(ingredients: @ingredient_strings) 
    assert_equal @ingredient_strings.length, @recipe.ingredients.length
  end

  test "it persists ingredients" do
    @recipe.assign_ingredients(@ingredient_strings)
    assert @recipe.save
    assert_equal 8, Ingredient.count
  end

  test "it creates author with single argument" do
    @recipe.author = 'bluegirl'
    assert @recipe.save
    assert_equal 1, @recipe.author_tag.count
  end

  test "it creates cousine with args array" do
    @recipe.cuisine = ['irish', 'british']
    assert @recipe.save
    assert_equal 2, @recipe.cuisine_tag.count
  end

end
