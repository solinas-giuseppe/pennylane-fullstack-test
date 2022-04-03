import * as React from 'react'
import * as ReactDOMClient from 'react-dom/client' 
import App from './react/App'
const node = document.getElementById('app')
const data = JSON.parse(node.getAttribute('data'))
// ReactDOM.hydrate(<App />, document.getElementById('app'))
const root = ReactDOMClient.createRoot(node);
root.render(<App {...data} />);