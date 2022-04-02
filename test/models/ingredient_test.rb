require "test_helper"

class IngredientTest < ActiveSupport::TestCase


  test "is not valid without a name" do
    ingredient = Ingredient.new
    assert_equal false, ingredient.valid?
  end

  test "it has a searchable column" do
    ingredient = ingredients(:all_purpose_flour)
    assert_not_nil ingredient.searchable
  end
end
