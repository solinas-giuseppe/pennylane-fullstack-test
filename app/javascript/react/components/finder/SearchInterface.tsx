import axios from "axios"
import { useRef, useState } from "react"
import styled from "styled-components"
import Ingredient from "./Ingredient"
import debounce from 'lodash.debounce';
import HighlightedText from "../HighlightedText";

const Wrapper = styled.div`
    background-color: var(--light-green);
    padding: 2rem;
`
const IngredientsResults = styled.div`
    padding: 2rem 0;
    background-color: var(--light-green);
    span {
        line-height: 1;
        border: 1px solid;
    }
`
const Input = styled.input`
    padding: .5rem;
    border-radius: .3rem;
`

const SearchInterface = ({keywords, setKeywords}) => {
    const input = useRef(null)
    const [results, setResults] = useState([])
    const [currentSearch, setCurrentSearch] = useState(null)

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
                setCurrentSearch(search)
                setResults(data)
            })
    }, 400)

    const handlePress = e => {
        if(e.key === 'Enter' && !!e.target.value) { 
            toggleIngredient(e.target.value)
            setResults([])
            setCurrentSearch(null)
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
                {!!currentSearch && <strong>{(results.length > 0 ? 'Press ENTER to add to recipe search' : `No results for keyword: ${currentSearch}`)}</strong>}
                <ul>
                    {(results.length > 0 ? results : []).map( i => 
                        <li key={i.id}>
                            <HighlightedText text={i.name} keywords={[currentSearch]} tagName="div"/>
                        </li>
                    )}
                </ul>
            </IngredientsResults>
        </Wrapper>
    )
}

export default SearchInterface