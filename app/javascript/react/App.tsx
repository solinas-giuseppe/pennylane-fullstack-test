import Layout from "./layout/Layout"
import RecipeFinder from "./components/RecipeFinder"
import { createGlobalStyle } from 'styled-components'

const GlobalStyle = createGlobalStyle`
    :root {
        --blue: #809bce;
        --azure: #95b8d1;
        --green: #b8e0d1;
        --light-green: #d6eadf;
        --pink: #eac4d5;
        --text-color: #123;
        --text-color-light: #30383f;
        --default: 'Montserrat', sans-serif;
        --decorated: 'Rubik Puddles', cursive;
    }
    html {
        font-size: 10px;
    }

    body {
        font-size: 1.6rem;
        font-family: var(--default);
        background-color: var(--blue);
        color: var(--text-color-light);
    }
    h1 {
        font-family: var(--decorated);
        font-size: 4rem;
        color: var(--text-color);
    }
    
    h2, h3, h4, h5, h6 {
        color: var(--text-color);

    }
`


const App = ({ingredients}) => {
    return (
        <Layout>
            <GlobalStyle />
            <RecipeFinder></RecipeFinder>
        </Layout>
    )
}

export default App