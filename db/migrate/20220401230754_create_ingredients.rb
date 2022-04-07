class CreateIngredients < ActiveRecord::Migration[7.0]
  def up
    create_table :ingredients do |t|
      t.string :name
      t.belongs_to :recipe, index: true
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE ingredients
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('english', coalesce(name, '')), 'A')
      ) STORED;
    SQL
  end

  def down
    drop_table :ingredients
  end
end
