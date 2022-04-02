require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  self.use_transactional_tests = true
  self.use_instantiated_fixtures = true
  setup do
    @recipe = recipes(:one)

  end
  test "the truth" do
    assert_equal "Golden Sweet Cornbread", @recipe.title
  end
end
