import styled from "styled-components"

const Header = () => {
    const HeaderStyle = styled.header`
        background-color: var(--pink);
        padding: 2rem;
    `

    return (
        <HeaderStyle>
            <h1>Find your recipe!</h1>
        </HeaderStyle>
    )
}
export default Header