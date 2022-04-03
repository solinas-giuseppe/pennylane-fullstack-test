import styled from "styled-components"
import Footer from "./Footer"
import Header from "./Header"
import Main from "./Main"

const Wrapper = styled.div`
    display: grid;
    grid-template-rows: 10rem 1fr 10rem;
    min-height: 100vh;
    max-height: 100vh;
    grid-auto-flow: dense;
    header { grid-row: 1;}
    main { grid-row: 2;}
    footer { grid-row: 3;}
`

const Layout = ({children}) => {
    return (
        <Wrapper>
            <Header />
            <Main>
                {children}
            </Main>
            <Footer />
        </Wrapper>
    )
}

export default Layout