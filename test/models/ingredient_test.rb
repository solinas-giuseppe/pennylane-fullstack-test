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

  test "it can be full-text searched" do
    searched = Ingredient.search_name('flour')
    assert_not_equal 0, searched.count
  end
end
