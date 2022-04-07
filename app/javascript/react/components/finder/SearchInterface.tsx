import axios from "axios"
import { useRef, useState } from "react"
import styled from "styled-components"
import Ingredient from "./Ingredient"
import debounce from 'lodash.debounce';

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

const SearchInterface = ({keywords, setKeywords}) => {
    const input = useRef(null)
    const [results, setResults] = useState([])


    const toggleIngredient = (name) => {
        setKeywords([
                ...keywords.filter( n => n != name ), 
                ...[(!!!keywords.find( n => n == name) ? name: null)]
            ].filter(Boolean).sort()
        )

        input.current.value = ""
    }

    const searchIngredients = debounce((search) => {
        axios.get('/ingredients/autocomplete.json', { params: {search } })
            .then( ({data}) => {
                setResults(data)
            })
    }, 400)

    const handlePress = e => {
        if(e.key === 'Enter' && !!e.target.value) { 
            toggleIngredient(e.target.value)
            setResults([])
        }
    }

    return (
        <Wrapper>
            <Input
                ref={input}
                type="text"
                placeholder="Search Ingredients!"
                onKeyPress={handlePress}
                onChange={ e => searchIngredients(e.target.value)}
            />
            <IngredientsResults>
                {(results.length > 0 ? results : []).map( i => 
                    <Ingredient
                        key={i.id}
<<<<<<< HEAD
                        selected={!!selectedIngredients.find( ({id}) => id == i.id )}
=======
                        selected={!!results.find( ({id}) => id == i.id )}
>>>>>>> remake
                        onClick={toggleIngredient}
                        {...i}
                    />
                )}
            </IngredientsResults>
        </Wrapper>
    )
}

export default SearchInterface