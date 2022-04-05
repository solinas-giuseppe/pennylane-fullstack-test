class AddImportedIdToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :imported_id, :integer, index: true, unique: true
  end
end
