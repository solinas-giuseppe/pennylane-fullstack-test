class CreateRecipeIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_ingredients do |t|
      t.belongs_to :recipe, index: true
      t.belongs_to :ingredient, index: true
      t.string :amount
      t.string :variant
      t.string :unit
      t.string :full_definition
      t.timestamps
    end

    add_index :recipe_ingredients, [:recipe_id, :ingredient_id] 
  end
end
