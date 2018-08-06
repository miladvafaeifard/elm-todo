module Main exposing (..)

import Html exposing (Html, text, div, h1, img, input, ul, li, button, span, a)
import Html.Attributes exposing (src, placeholder, type_, checked, value, class, attribute, href, readonly)
import Html.Events exposing (onClick, onInput)
import Debug exposing (..)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Button as Button
import Bootstrap.ListGroup as ListGroup


---- MODEL ----


type alias Todo =
    { id : Int
    , title : String
    , completed : Bool
    }


type alias Model =
    { field : String
    , uid : Int
    , todos : List Todo
    }


init : ( Model, Cmd Msg )
init =
    ( { todos = [], field = "", uid = 0 }, Cmd.none )



---- UPDATE ----


type Msg
    = Add
    | Delete Int
    | UpdateField String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateField field ->
            ( { model | field = field }, Cmd.none )

        Add ->
            if model.field /= "" then
                let
                    todo =
                        [ { id = model.uid, title = model.field, completed = False } ]
                in
                    ( { model | field = "", uid = model.uid + 1, todos = model.todos ++ todo }, Cmd.none )
            else
                ( model, Cmd.none )

        Delete id ->
            ( { model | todos = filterId id model.todos }, Cmd.none )


filterId : Int -> List Todo -> List Todo
filterId id =
    List.filter (\a -> a.id /= id)



---- VIEW ----


view : Model -> Html Msg
view model =
    Grid.container [] 
        [ CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
        , div []
            [ h1 [] [ text "Elm Todo" ]
            , div [ class "input-group mb-3" ]
              [
                input [ type_ "text", class "form-control", onInput UpdateField, value model.field, placeholder "What's your task today?" ] []
              , div [ class "input-group-append" ] 
                [
                  Button.button [ Button.primary, Button.onClick Add ] [ text "Add" ]
                ]
              ]
           ]
           , ListGroup.ul (renderList model.todos)
        ]

renderList : List Todo -> List (ListGroup.Item Msg)
renderList =
    List.map (\v -> ListGroup.li [] [ text v.title ])

    -- [ input [ type_ "checkbox", checked a.completed ] []
    -- , text a.title
    -- , Button.button [ Button.danger, Button.onClick (Delete a.id) ] [ text "Delete" ]
    -- ]


---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
