class Recipe < ApplicationRecord
    validates :title, presence: true
    has_many :filtered_recipe_ingredients, inverse_of: :recipe, autosave: true, class_name: 'RecipeIngredient'
    has_many :recipe_ingredients, inverse_of: :recipe, autosave: true
    has_many :ingredients, inverse_of: :recipes, through: :recipe_ingredients, autosave: true
    
    TAG_CONTEXTS = [:cuisine, :category, :author].freeze

    acts_as_taggable_on *TAG_CONTEXTS.map { |t| "#{t}_tag"}

    # def ingredients=(ingredient_strings) # TODO: delete after imports
    #     assign_ingredients(ingredient_strings)
    # end

    TAG_CONTEXTS.each do |m|
        define_method "#{m}=" do |*args|
            self.send("#{m}_tag_list=", args.map(&:presence).compact)
        end

        define_method "#{m}" do
            self.send("#{m}_tag").map(&:name)
        end
    end

    def assign_ingredients(ingredient_strings)
        ingredient_strings.each do |i|
            self.recipe_ingredients << RecipeIngredient.new({full_definition: i})
        end
    end
end
