require 'yajl'
class RecipesBridge < ActiveRecord::Base
end

def createTemporaryTable
    name = "recipes_import_#{Time.now.strftime "%d%m%Y_%H%M%S_%3N"}"
    dropTemporaryTable(name)
    ActiveRecord::Base.connection.execute <<-SQL
        CREATE TABLE #{name} (
            id SERIAL PRIMARY KEY,
            title VARCHAR(255),
            cook_time INT,
            prep_time INT,
            ingredients VARCHAR ARRAY,
            ratings NUMERIC,
            cuisine VARCHAR(255),
            category VARCHAR(255),
            author VARCHAR(255),
            image VARCHAR(255)
        );
    SQL
    name
end

def dropTemporaryTable(name)
    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS #{name}")
end

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
        RecipesBridge.table_name = createTemporaryTable
        puts "# BRING DATA IN"
        RecipesBridge.insert_all results
        puts "# INSERT RECIPES"
        recipe_columns = [:title, :cook_time, :prep_time, :ratings, :image]
        Recipe.insert_all RecipesBridge.pluck(:id, *recipe_columns).map { |d| [:imported_id, *recipe_columns].zip(d).to_h}
        

        puts '# CREATE INGREDIENTS'
        Ingredient.insert_all RecipesBridge.joins(%Q(
            INNER JOIN recipes ON recipes.imported_id = #{RecipesBridge.table_name}.id
        )).pluck('recipes.id', :ingredients).map {|d| d[1].zip([*d[0]]*d[1].length).map { |q| [:name, :recipe_id].zip(q).to_h}.flatten }.flatten       
        
        puts "# INSERT TAGS"
        Recipe::TAG_CONTEXTS.each do |c|
            puts "## TAG : #{c}"
            ActsAsTaggableOn::Tag.insert_all RecipesBridge.distinct.pluck(c).map { |d| [:name].zip([d]).to_h}
            puts "## TAG : #{c} - TAGGINGS"
            ActsAsTaggableOn::Tagging.insert_all RecipesBridge.joins(%Q(
                INNER JOIN tags ON tags.name = #{RecipesBridge.table_name}.#{c}
                INNER JOIN recipes ON recipes.imported_id = #{RecipesBridge.table_name}.id
            )).group('recipes.id', 'tags.id').pluck(
                Arel.sql('tags.id'),
                Arel.sql(%Q('Recipe')),
                Arel.sql('recipes.id'),
                Arel.sql(%Q('#{c}_tag'))
            ).map { |d| [:tag_id, :taggable_type, :taggable_id, :context].zip(d).to_h}
        end
        dropTemporaryTable(RecipesBridge.table_name)
    end
end