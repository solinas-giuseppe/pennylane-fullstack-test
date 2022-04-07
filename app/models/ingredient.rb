class Ingredient < ApplicationRecord
    validates :name, presence: true
    belongs_to :recipe, inverse_of: :ingredients
    scope :autocomplete_scope, ->(search) { search_name(search) }
    include PgSearch::Model
    pg_search_scope :search_name,
        against: { name: 'A' },
        using: {
            tsearch: {
            dictionary: 'english', tsvector_column: 'searchable'
        }
    }
    def self.autocomplete(search=nil)
        autocomplete_scope(search).limit(30)
    end
end
