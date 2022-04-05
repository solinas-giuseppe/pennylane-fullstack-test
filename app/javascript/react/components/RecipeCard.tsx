import styled from "styled-components"
import StarRatings from 'react-star-ratings'
import CookIcon from "./icons/CookIcon"
import PrepIcon from "./icons/PrepIcon"
export const Card = styled.div`
    background-color: white;
    border-radius: .7rem;
    padding: 1.5rem;
    display: grid;
    gap: 1.5rem;
    @media screen and (min-width: 768px) {
        header {
            grid-column: 2;
        }
        .card-body {
            grid-column: 1;
        }
        grid-template-columns: 3fr 1fr;
    }
`

const CardHeader = styled.header`
    display: grid;
    gap: 1.5rem;
    grid-auto-rows: min-content;
    /* overflow: hidden; */
    .image {
        margin: -1.5rem -1.5rem 0;
        border-top-left-radius: .7rem;
        border-top-right-radius: .7rem;
        overflow: hidden;
        
        @media screen and (min-width: 768px) {
            border-top-left-radius: 0;
            border-top-right-radius: 0;
            margin: 0;
        }
    }
    img {
        width: 100%;
        height: 22rem;
        object-fit: cover;
    }
`

const CardBody = styled.div`
    display: grid;
    gap: 1.5rem;
`

const CardBodyTop = styled.div`
    display: grid;
    grid-template-columns: 1fr 19rem;
    gap: 1.5rem;
    > * { min-height: 0;min-width: 0; }
`

const CardFooter = styled.footer`
    div {
        display: inline-block;
        padding-right: 1rem;
        & + div {
            padding-left: 1rem;
            border-left: 1px solid;
        }
    }
`
const DetailsWrapper = styled.div`
    display: flex;
    div + div {
        margin-left: 1rem;
    }
    @media screen and (min-width: 768px) {
        grid-row: 1;
    }
`

const TimeEl = styled.div`
    svg {
        height: 1.8rem;
    }
`

const highlightText = (text, keywords) => {
    if (keywords.length == 0) return text
    const highlightRegex = new RegExp(`(${(keywords || []).join('|')})`)
    return text.replace(highlightRegex,'<strong>$1</strong>')
}

const RecipeCard = ({
    id,
    title,
    author,
    cuisine,
    category,
    ratings,
    cook_time,
    prep_time,
    image,
    ingredients,
    keywords
}) => {
    const [authorName] = author
    const [cuisineName] = cuisine
    const [categoryName] = category
    
    return (
        <Card>
            <CardHeader>
                <div className={"image"}>
                    <img loading="lazy" src={image} alt={title} />
                </div>
                {(!!prep_time || !!cook_time) && <DetailsWrapper>
                    {!!prep_time && <TimeEl title="Prep Time"><PrepIcon /> {prep_time} mins</TimeEl>}
                    {!!cook_time && <TimeEl title="Cook Time"><CookIcon /> {cook_time} mins</TimeEl>}
                </DetailsWrapper>}
            </CardHeader>
            <CardBody className={'card-body'}>
                <CardBodyTop>
                    <h3>{title}</h3>
                    <div>
                        <span>

                            <StarRatings
                                rating={ratings}
                                starRatedColor="#dcda56"
                                starDimension="2.5rem"
                                starSpacing=".1rem"
                            />
                        </span>
                        &nbsp;
                        ({ratings})
                    </div>
                </CardBodyTop>
                <ul>
                    {ingredients.map((i, idx)=> <li key={idx}>
                        <span dangerouslySetInnerHTML={{__html: highlightText(i, keywords)}}></span>
                    </li>)}
                </ul>
            </CardBody>
            <CardFooter>
                {authorName && <div>By {authorName}</div>}
                {[cuisineName, categoryName].filter(Boolean).map((detail, i) => <div key={i}>{detail}</div>)}
            </CardFooter>
        </Card>
    )
}
export default RecipeCard