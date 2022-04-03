import { useContext, useState } from "react"
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
    const [results, setResults] = useState([])
    const addIngredient = (ingredient) => {
        setSelectedIngredients([
            ...selectedIngredients.filter(({id}) => id != ingredient.id),
            ingredient
        ])
    }

    const searchIngredients = debounce((e) => {
        const search = e.target.value
        axios.get('/ingredients/autocomplete.json', { params: {search } })
            .then( ({data}) => {
                setResults(data)
            })
    }, 400)

    return (
        <Wrapper>
            <Input type="text" placeholder="Search Ingredients!" onChange={ e => searchIngredients(e)}/>
            <IngredientsResults>
                {(results.length > 0 ? results : startingIngredients).map( i => 
                    <Ingredient
                        key={i.id}
                        selected={!!selectedIngredients.find( ({id}) => id == i.id )}
                        onClick={addIngredient}
                        {...i}
                    />
                )}
            </IngredientsResults>
        </Wrapper>
    )
}

export default SearchInterface