class Ingredient < ApplicationRecord
    validates :name, presence: true
    has_many :recipe_ingredients, inverse_of: :ingredient, autosave: true
    has_many :recipes, inverse_of: :ingredients, through: :recipe_ingredients, autosave: true
    include PgSearch::Model
    pg_search_scope :search_name,
        against: { name: 'A' },
        using: {
            tsearch: {
            dictionary: 'english', tsvector_column: 'searchable'
        }
    }

    def self.find_by_full_name(full_definition)
        auto_attrs = RecipeIngredient.parse_definition(full_definition)
        Ingredient.find_or_initialize_by({name: auto_attrs['name']})
    end
end
