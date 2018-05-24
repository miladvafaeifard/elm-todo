module Main exposing (..)

import Html exposing (Html, text, div, h1, img, input, ul, li, button)
import Html.Attributes exposing (src, placeholder, type_, checked)
import Html.Events exposing (onClick, onInput)


---- MODEL ----
type alias Todo = 
    {
        title: String
    ,   completed: Bool
    }

type alias Model =
    { 
        todos: List Todo
    }


init : ( Model, Cmd Msg )
init =
    ( { todos = [] } , Cmd.none )



---- UPDATE ----


type Msg =
     Add


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Add ->
            let
                todo = [{ title = "Buy Car", completed = False }]
            in
                ({ model | todos = model.todos ++ todo }, Cmd.none)



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Elm Todo" ]
        , input [ type_ "text" ] []
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
