module Main exposing (..)

import Html exposing (Html, text, div, h1, img, input, ul, li, button)
import Html.Attributes exposing (src, placeholder, type_, checked, value)
import Html.Events exposing (onClick, onInput)

import Debug exposing (..)

---- MODEL ----
type alias Todo = 
    {
        id: Int
    ,   title: String
    ,   completed: Bool
    }

type alias Model =
    { 
        field: String
    ,   uid: Int
    ,   todos: List Todo
    }


init : ( Model, Cmd Msg )
init =
    ({ todos = [], field = "", uid = 0 }, Cmd.none )



---- UPDATE ----


type Msg =
       Add
    |  Delete Int 
    |  UpdateField String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateField field ->
                ({ model | field = field }, Cmd.none)
        Add ->
            let
                todo = [{ id = model.uid, title = model.field, completed = False }]
            in
                ({ model | field = "", uid = model.uid +1, todos = model.todos ++ todo }, Cmd.none)
        Delete id ->
                ({ model | todos = filterId id model.todos }, Cmd.none)

filterId: Int -> List Todo -> List Todo
filterId id = 
    List.filter (\a -> a.id /= id)

---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ 
          h1 [] [ text "Elm Todo" ]
        , input [ type_ "text", onInput UpdateField,  value model.field] []
        , button [ onClick Add ][ text "Add" ]
        , ul [] (renderList model.todos)
        ]

renderList: List Todo -> List (Html Msg)
renderList =
    (List.map (\a -> 
    li [] 
        [ 
          input [ type_ "checkbox", checked a.completed ] []
        , text a.title 
        , button [ onClick (Delete a.id) ] [ text "Delete" ]
        ]
    ))

---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
