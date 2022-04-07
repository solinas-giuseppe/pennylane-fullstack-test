import axios from "axios"
import { useEffect, useState } from "react"
import styled from "styled-components"
import Ingredient from "./finder/Ingredient"
import SearchInterface from "./finder/SearchInterface"
import RecipeCard, { Card } from "./RecipeCard"

const Wrapper = styled.div`
    display: grid;
    @media screen and (min-width: 768px) {
        height: 100%;
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
    const [keywords, setKeywords] = useState(JSON.parse(sessionStorage.getItem('keywords')) || [])
    const [recipes, setRecipes] = useState([])
    const unSelectKewords = (name) => {
        setKeywords(keywords.filter((n) => String(n) != String(name)))
    }

    const searchRecipes = (searches) => {
        axios.get('/recipes/search.json', {params: {searches }}).then(({data}) => {
            setRecipes(data)
            sessionStorage.setItem('keywords', JSON.stringify(keywords))
        })
    }

    useEffect(() => { searchRecipes(keywords) }, [keywords])

    return (
        <Wrapper>
            <SearchInterface {...{keywords, setKeywords}} />
            <div>
                <RecipesHeader>
                    {!keywords.length ? 'Select Ingredients' : <>
                        Selected Ingredients: {keywords.map((name, i) =>
                            <Ingredient
                                key={i}
                                onClick={unSelectKewords}
                                selected={true}
                                name={name}
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