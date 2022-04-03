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
        results.each_slice(500) do | batch |
            recipes = []
            recipe_ingredients = []
            ingredients = []
            puts "New Batch of 500 records. #{Recipe.count} already in"
            batch.each do | element |
                Recipe.new(element.slice(
                    "title",
                    "cook_time",
                    "prep_time",
                    "ratings",
                    "cuisine",
                    "category",
                    "author",
                    "image",
                )).yield_self do |recipe|
                    recipes << recipe
                    recipe_ingredients += element['ingredients'].uniq.map do |d|
                        Ingredient.find_by_full_name(d).yield_self do |i|
                            ingredients << i if i.present? and i.new_record?
                            ri = RecipeIngredient.new({ full_definition: d, recipe: recipe, ingredient: i })
                            ri
                        end
                    end
                end
                print '.'
            end
            Recipe.import(recipes, recursive: true)
            Ingredient.import(ingredients)
            RecipeIngredient.import(recipe_ingredients, on_duplicate_key_update: [:ingredient_id, :recipe_id])
            puts %Q(
                Recipes : #{Recipe.count}
                Ingredients : #{Ingredient.count}
                RecipeIngredients : #{RecipeIngredient.count}
            )
        end
  
    end
end