require 'uri'
require 'yajl/gzip'
require 'yajl/deflate'
require 'yajl/http_stream'

namespace :recipes do
    desc "Import data"
    task :import => :environment do
        Dir.glob("#{Rails.root}/app/models/*.rb").each { |file| require file }
        # content-type application/x-gzip is not supported by yajl
        # url = URI.parse("https://pennylane-interviewing-assets-20220328.s3.eu-west-1.amazonaws.com/recipes-en.json.gz")
        # results = Yajl::HttpStream.get(url)
        json = File.open([Rails.root, 'public', 'recipes-en.json'].join('/'), 'r')
        parser = Yajl::Parser.new
        results = parser.parse(json)

        results.each_slice(1000) do |batch|
            tags = []
            batch.each do | element |
                Recipe::TAG_CONTEXTS.map(&:to_s).each do |t|
                    if element[t].present?
                        tag = ActsAsTaggableOn::Tag.find_or_initialize_by(name: element[t])
                        tags << tag if tag.new_record?
                    end
                end
            end
            ActsAsTaggableOn::Tag.import!(tags, ignore: true)
            puts "Imported #{ActsAsTaggableOn::Tag.count} Tags"
        end

        results.each_slice(400) do |batch|
            recipes = []
            recipe_ingredients = []
            ingredients = []
            puts "New Batch of 400 records. #{Recipe.count} already in"
            batch.each do | element |
                Recipe.new(element.slice(
                    "title",
                    "cook_time",
                    "prep_time",
                    "ratings",
                    "image",
                )).yield_self do |recipe|
                    Recipe::TAG_CONTEXTS.map(&:to_s).each do |t|
                        if element[t].present?
                            recipe.taggings.build(
                                tag: ActsAsTaggableOn::Tag.find_by(name: element[t]),
                                taggable: recipe,
                                context: "#{t}_tag"
                            )
                        end
                    end
                    
                    recipe_ingredients += element['ingredients'].uniq.map do |d|
                        Ingredient.find_by_full_name(d).yield_self do |i|
                            ingredients << i if i.present? and i.new_record?
                            ri = RecipeIngredient.new({ full_definition: d, recipe: recipe, ingredient: i })
                            # i.recipe_ingredients << ri
                            ri
                        end
                    end
                    recipes << recipe
                end
                print '.'
            end
            # ActsAsTaggableOn::Tag.has_many :taggings, inverse_of: :tag, autosave: true
            # ActsAsTaggableOn::Tagging.belongs_to :tag, inverse_of: :taggings, autosave: true
            # pp recipes
            begin
            
            Recipe.import(recipes, recursive: true)
            Ingredient.import(ingredients, recursive: true)
            rescue => e
                pp e.record
                pp e.record.recipe_ingredients
                pp e.record.recipe_ingredients.first.recipe
                raise e
            end
            # RecipeIngredient.import!(recipe_ingredients, on_duplicate_key_update: [:ingredient_id, :recipe_id])
            
            # ActsAsTaggableOn::Tagging.import!(taggings, on_duplicate_key_update: [:tag_id, :taggable_type, :taggable_id], validate: true)
            puts %Q(
                Recipes : #{Recipe.count}
                Ingredients : #{Ingredient.count}
                RecipeIngredients : #{RecipeIngredient.count}
                Taggings : #{ActsAsTaggableOn::Tagging.count}
                Tags : #{ActsAsTaggableOn::Tag.count}
            )
        end
  
    end
end