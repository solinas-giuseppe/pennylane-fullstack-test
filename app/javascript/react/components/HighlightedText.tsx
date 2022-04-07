const highlightText = (text, keywords) => {
    if (keywords.length == 0) return text
    const highlightRegex = new RegExp(`(${(keywords || []).join('|')})`, 'i')
    return text.replace(highlightRegex, '<strong>$1</strong>')
}

const HighlightedText = ({text, keywords, tagName}) => {
    const Tag = tagName || 'span'
    if (tagName == 'div') console.log(keywords)
    return <Tag dangerouslySetInnerHTML={{__html: highlightText(text, keywords)}}></Tag>
}

export default HighlightedText