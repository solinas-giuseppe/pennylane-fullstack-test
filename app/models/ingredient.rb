class Ingredient < ApplicationRecord
    validates :name, presence: true
    has_many :recipe_ingredients, inverse_of: :ingredient, autosave: true
    has_many :recipes, inverse_of: :ingredients, through: :recipe_ingredients, autosave: true
    scope :autocomplete_scope, ->(search) {
        (search.present? ? search_name(search) : all).yield_self do |query|
            query
                .joins(:recipe_ingredients)
                .group(:id)
                .reorder(%Q(COUNT(recipe_ingredients.id) DESC))
                .limit(10)
                .pluck(:id, :name)
        end
    }
    include PgSearch::Model
    pg_search_scope :search_name,
        against: { name: 'A' },
        using: {
            tsearch: {
            dictionary: 'english', tsvector_column: 'searchable'
        }
    }
    def self.autocomplete(search=nil)
        autocomplete_scope(search).to_a.map { |d| d.zip([:id, :name]).to_h.invert}
    end

    def self.find_by_full_name(full_definition)
        auto_attrs = RecipeIngredient.parse_definition(full_definition)
        Ingredient.find_or_initialize_by({name: auto_attrs['name']})
    end
end
