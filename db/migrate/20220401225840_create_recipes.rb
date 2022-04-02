class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.float :cook_time
      t.float :prep_time
      t.float :ratings
      t.string :image
      t.timestamps
    end
  end
end
