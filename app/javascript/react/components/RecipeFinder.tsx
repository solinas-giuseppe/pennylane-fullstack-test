import axios from "axios"
import { useEffect, useState } from "react"
import styled from "styled-components"
import Ingredient from "./finder/Ingredient"
import SearchInterface from "./finder/SearchInterface"
import RecipeCard from "./RecipeCard"

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
    const [recipes, setRecipes] = useState([])
    const unSelectIngredients = (ingredient) => {
        setSelectedIngredients(selectedIngredients.filter(({id}) => String(id) != String(ingredient.id)))
    }

    useEffect(() => {
        const ingredient_ids = selectedIngredients.map(({id}) => id)
        axios.get('/recipes/search.json', {params: {ingredient_ids}}).then(({data}) => {
            console.log(data)
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
                        {recipes.map((recipe) => <RecipeCard key={recipe.id} {...recipe}></RecipeCard>)}
                    </RecipesList>
                </RecipesListWrapper>
            </div>
        </Wrapper>

    )
}
export default RecipeFinder