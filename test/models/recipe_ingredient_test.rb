require "test_helper"

class RecipeIngredientTest < ActiveSupport::TestCase
  @recipe = Recipe.first
  setup do 
    @full_definitions = [
      "1 cup all-purpose flour",
      "1 cup yellow cornmeal",
      "⅔ cup white sugar",
      "1 ½ (.25 ounce) packages active dry yeast",
      "rice flour for bread form (banneton)",
      "1 (8 ounce) can cream-style corn",
      "3 ½ teaspoons baking powder",
      "1 egg",
      "1 cup milk",
      "⅓ cup vegetable oil",
      "2 cups all-purpose flour",
      "¾ cup white sugar",
      "2 teaspoons baking powder",
      "¼ teaspoon ground nutmeg",
      "¼ teaspoon ground cinnamon",
      "1 teaspoon salt",
      "¾ cup milk",
      "2 eggs, beaten",
      "1 teaspoon vanilla extract",
      "1 tablespoon shortening",
      "1 cup confectioners' sugar",
      "2 tablespoons hot water",
      "½ teaspoon almond extract",
      "1 (4 ounce) can diced green chile peppers, drained",
      "1 10-inch banneton (proofing basket)"
    ]

  end

  test "it assigns the proper attributes" do
    recipe_ingredient = RecipeIngredient.new(recipe: @recipe, full_definition: @full_definitions[0])
    assert_equal "1", recipe_ingredient.amount.strip
    assert_equal "cup", recipe_ingredient.unit.strip
    assert_nil recipe_ingredient.variant
    assert_equal @full_definitions[0], recipe_ingredient.full_definition
  end

  test "it makes the unit singular" do
    recipe_ingredient = RecipeIngredient.new(recipe: @recipe, full_definition: @full_definitions[12])
    assert_equal "teaspoon", recipe_ingredient.unit.strip
  end

  test "it initializes an ingredient when initialized" do
    recipe_ingredient = RecipeIngredient.new(recipe: @recipe, full_definition: @full_definitions[0])
    assert_not_nil recipe_ingredient.ingredient
    assert_equal "all-purpose flour", recipe_ingredient.ingredient.name
  end
end
