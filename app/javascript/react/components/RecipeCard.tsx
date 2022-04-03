import styled from "styled-components"
import StarRatings from 'react-star-ratings'
import CookIcon from "./icons/CookIcon"
import PrepIcon from "./icons/PrepIcon"
const Card = styled.div`
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
    grid-template-columns: 1fr 14rem;
    gap: 1.5rem;
`

const CardFooter = styled.footer`

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
}) => {
    return (
        <Card>
            <CardHeader>
                <div>
                    <img {...{lazy: true}} src={image} alt={title} />
                </div>
                <DetailsWrapper>
                    {!!prep_time && <TimeEl title="Prep Time"><PrepIcon /> {prep_time} mins</TimeEl>}
                    {!!cook_time && <TimeEl title="Cook Time"><CookIcon /> {cook_time} mins</TimeEl>}
                </DetailsWrapper>
            </CardHeader>
            <CardBody className={'card-body'}>
                <CardBodyTop>
                    <h3>{title}</h3>
                    <div>
                        <StarRatings
                            rating={ratings}
                            starRatedColor="#dcda56"
                            starDimension="2.5rem"
                            starSpacing=".1rem"
                        />
                    </div>
                    

                </CardBodyTop>
                <ul>
                    {ingredients.map((i, idx)=> <li key={idx}>{i}</li>)}
                </ul>
            </CardBody>
            <CardFooter>


            </CardFooter>
        </Card>
    )
}
export default RecipeCard