require "test_helper"

class RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipe = recipes(:one)
  end

  test "searches recipes" do
    get search_recipes_url(format: :json, searches: [:salt, :pepper])
    assert_response :success
  end

  
end
