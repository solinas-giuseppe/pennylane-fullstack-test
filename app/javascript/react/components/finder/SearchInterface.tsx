import { useContext, useRef, useState } from "react"
import styled from "styled-components"
import AppContext from "../../contexts/AppContext"
import Ingredient from "./Ingredient"
import debounce from 'lodash.debounce';
import axios from "axios";

const Wrapper = styled.div`
    background-color: var(--light-green);
    padding: 2rem;
`
const IngredientsResults = styled.div`
    padding: 2rem 0;
    background-color: var(--light-green);
`
const Input = styled.input`
    padding: .5rem;
    border-radius: .3rem;
`

const SearchInterface = ({selectedIngredients, setSelectedIngredients}) => {
    const { startingIngredients } = useContext(AppContext)
    const input = useRef(null)
    const [results, setResults] = useState([])

    const searchIngredients = debounce((search) => {
        axios.get('/ingredients/autocomplete.json', { params: {search } })
            .then( ({data}) => {
                setResults(data)
            })
    }, 400)

    const toggleIngredient = (ingredient) => {
        const ingredientPresence = !!selectedIngredients.find(({id}) => id == ingredient.id)
        setSelectedIngredients([
            ...selectedIngredients.filter(({id}) => id != ingredient.id ),
            (!ingredientPresence ? ingredient : null)
        ].filter(Boolean).sort((a, b) => a.name > b.name ? 1 : -1))
        if (!!input.current.value.length) {
            input.current.value = ""
            searchIngredients('')
        }
    }

    return (
        <Wrapper>
            <Input ref={input} type="text" placeholder="Search Ingredients!" onChange={ e => searchIngredients(e.target.value)}/>
            <IngredientsResults>
                {(results.length > 0 ? results : startingIngredients).map( i => 
                    <Ingredient
                        key={i.id}
                        selected={!!selectedIngredients.find( ({id}) => id == i.id )}
                        onClick={toggleIngredient}
                        {...i}
                    />
                )}
            </IngredientsResults>
        </Wrapper>
    )
}

export default SearchInterface