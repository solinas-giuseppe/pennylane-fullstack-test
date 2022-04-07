class Recipe < ApplicationRecord
    validates :title, presence: true
    has_many :ingredients, inverse_of: :recipe, autosave: true
    TAG_CONTEXTS = [:cuisine, :category, :author].freeze

    acts_as_taggable_on *TAG_CONTEXTS.map { |t| "#{t}_tag"}

    # def ingredients=(ingredient_strings) # TODO: delete after imports
    #     assign_ingredients(ingredient_strings)
    # end

    TAG_CONTEXTS.each do |m|
        define_method "#{m}=" do |*args|
            self.send("#{m}_tag_list_will_change!")
            self.send("#{m}_tag_list=", args.map(&:presence).compact)
        end

        define_method "#{m}" do
            self.send("#{m}_tag").map(&:name)
        end
    end
end
