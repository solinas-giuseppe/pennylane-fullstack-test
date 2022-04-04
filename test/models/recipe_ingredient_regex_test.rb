require "test_helper"

class RecipeIngredientTest < ActiveSupport::TestCase

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
      "1 10-inch banneton (proofing basket)",
      "½ cup (packed) dark brown sugar"
    ]

    @attributes = @full_definitions.map { |d|
      begin
       RecipeIngredient.parse_definition(d)
      rescue
        puts "ERROR on '#{d}'" 
      end
    }
  end

  test "it detects variant in non-standard position" do
    assert_equal "(packed)", @attributes.last["variant"]
    assert_not_nil @attributes.last["name"]
  end

  test "it extracts digit amounts" do
    assert_equal "1", @attributes[0]["amount"].strip
    assert_equal "2", @attributes[10]["amount"].strip
  end

  test "it extracts fraction amounts" do
    assert_equal "⅔", @attributes[2]["amount"].strip
    assert_equal "¼", @attributes[13]["amount"].strip
    assert_equal "¾", @attributes[16]["amount"].strip
  end

  test "it extracts digit plus fraction amounts" do
    assert_equal "3 ½", @attributes[6]["amount"].strip
  end

  test "it extracts digit plus parentheses amount" do
    assert_equal "1 (8 ounce)", @attributes[5]["amount"].strip
    assert_equal "1 (4 ounce)", @attributes[23]["amount"].strip
  end
  
  test "it extracts digit plus fraction plus parentheses amount" do
    assert_equal "1 ½ (.25 ounce)", @attributes[3]["amount"].strip
  end

  test "it does not include name digits in amount" do
    assert_equal "1", @attributes[24]["amount"].strip
    assert_equal "10-inch banneton", @attributes[24]["name"].strip
  end

  test "it extracts units" do
    assert_equal "cup", @attributes[0]["unit"] 
    assert_equal "package", @attributes[3]["unit"] 
    assert_nil @attributes[7]["unit"] 
    assert_equal "teaspoon", @attributes[13]["unit"] 
  end

  test "it extracts names" do
    assert_equal "all-purpose flour", @attributes[0]["name"].strip
    assert_equal "active dry yeast", @attributes[3]["name"].strip
    assert_equal "rice flour for bread form", @attributes[4]["name"].strip
  end

  test "it extracts variants" do
    assert_equal "(banneton)", @attributes[4]["variant"]
    assert_equal "beaten", @attributes[17]["variant"]
    assert_equal "drained", @attributes[23]["variant"]
    assert_equal "(proofing basket)", @attributes[24]["variant"]
  end
end
