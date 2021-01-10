port module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, h2, input, p, text)
import Html.Events exposing (onInput)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { itemKeyToSet : String
    , itemValueToSet : String
    }



-- INIT


initialModel : Model
initialModel =
    { itemKeyToSet = "test1"
    , itemValueToSet = ""
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )



-- UPDATE


type Msg
    = SetItemValue String



-- = GetItem String
-- | SetItemValue String


type alias LocalStorageItem =
    { key : String
    , value : String
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetItemValue newValue ->
            ( { model | itemValueToSet = newValue }, setItem { key = "test1", value = model.itemValueToSet } )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "localStorage example" ]
        , div []
            [ h2 [] [ text "Set Item" ]
            , div []
                [ p [] [ text ("Key: " ++ model.itemKeyToSet) ]
                , input [ onInput SetItemValue ] []
                ]
            ]
        ]



-- PORTS


port setItem : LocalStorageItem -> Cmd msg



-- port requestItem : (String -> msg) -> Sub msg
-- port arrivingItem : (String -> msg) -> Sub msg
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
