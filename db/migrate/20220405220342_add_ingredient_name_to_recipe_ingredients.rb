class AddIngredientNameToRecipeIngredients < ActiveRecord::Migration[7.0]
  def change
    add_column :recipe_ingredients, :name, :string
  end
end
