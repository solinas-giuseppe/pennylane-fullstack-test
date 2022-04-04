import axios from "axios"
import { useEffect, useState } from "react"
import styled from "styled-components"
import Ingredient from "./finder/Ingredient"
import SearchInterface from "./finder/SearchInterface"
import RecipeCard, { Card } from "./RecipeCard"

const Wrapper = styled.div`
    display: grid;

    @media screen and (min-width: 768px) {
        grid-template-columns: 1fr 3fr;
    }
`
const RecipesHeader = styled.header`
    background-color: white;
    padding: 2rem;
`

const RecipesListWrapper = styled.div`
    overflow-y: scroll;
    padding: 2rem;
`
const RecipesList = styled.div`
    display: grid;
    gap: 3rem;
    padding: 2rem;
`

const RecipeFinder = () => {
    const [selectedIngredients, setSelectedIngredients] = useState([])
    const [keywords, setKeywords] = useState([])
    const [recipes, setRecipes] = useState([])
    const unSelectIngredients = (ingredient) => {
        setSelectedIngredients(selectedIngredients.filter(({id}) => String(id) != String(ingredient.id)))
    }

    useEffect(() => {
        setKeywords(selectedIngredients.map(({name}) => name))
        const ingredient_ids = selectedIngredients.map(({id}) => id)
        axios.get('/recipes/search.json', {params: {ingredient_ids}}).then(({data}) => {
            setRecipes(data)
        })
    },[selectedIngredients])

    return (
        <Wrapper>
            <SearchInterface {...{selectedIngredients, setSelectedIngredients}} />
            <div>
                <RecipesHeader>
                    {!selectedIngredients.length ? 'Select Ingredients' : <>
                        Selected Ingredients: {selectedIngredients.map((i) =>
                            <Ingredient
                                key={i.id}
                                onClick={unSelectIngredients}
                                {...i}
                            />)}
                    </>}
                </RecipesHeader>
                <RecipesListWrapper>
                    <RecipesList>
                        {(!recipes || recipes.length) == 0
                            ?
                            <Card>No recipes found {keywords.length > 0 && 'with'} {keywords.join(', ')}</Card>
                            :
                            recipes.map((recipe) => <RecipeCard
                                key={recipe.id}
                                {...recipe}
                                keywords={keywords}
                            />)}
                    </RecipesList>
                </RecipesListWrapper>
            </div>
        </Wrapper>

    )
}
export default RecipeFinder