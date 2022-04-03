import styled from "styled-components"

const IngredientStyle = styled.a`
    display: inline-block;
    border-radius: .3rem;
    padding: .5rem;
    margin: .2rem;
    box-shadow: 2px 2px 2px 0px var(--text-color);
    &.selected {
        background-color: var(--green);
    }
`

const Ingredient = ({name, id, selected, onClick}) => {
    return (
        <IngredientStyle
            onClick={ () => onClick({name, id})}
            className={selected ? 'selected' : ''}
        >
            + {name}
        </IngredientStyle>
    )
}

export default Ingredient