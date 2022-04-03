json.extract! recipe, *[
    :id,
    :title,
    :ratings,
    :cook_time,
    :prep_time,
    :image,
    *Recipe::TAG_CONTEXTS,
]
json.ingredients do
    json.array! recipe.recipe_ingredients.map(&:full_definition)
end
json.url recipe_url(recipe, format: :json)
