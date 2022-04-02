class Ingredient < ApplicationRecord
    validates :name, presence: true
    include PgSearch::Model
    pg_search_scope :search_name,
        against: { name: 'A' },
        using: {
            tsearch: {
            dictionary: 'english', tsvector_column: 'searchable'
        }
    }
end
