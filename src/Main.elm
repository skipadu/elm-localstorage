port module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, h2, input, label, p, text)
import Html.Attributes exposing (disabled, for, id, readonly, value)
import Html.Events exposing (onClick, onInput)



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
    { key : String
    , value : String
    , keyToGet : String
    , valueGot : String
    , keyToRemove : String
    }



-- INIT


initialModel : Model
initialModel =
    { key = "test1"
    , value = ""
    , keyToGet = ""
    , valueGot = ""
    , keyToRemove = ""
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )



-- UPDATE


type Msg
    = SetValue String
    | StoreItem
    | SetKey String
    | SetKeyToGet String
    | GetItem String
    | GotItem String
    | SetKeyToRemove String
    | RemoveItem
    | Clear


type alias LocalStorageItem =
    { key : String
    , value : String
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetValue newValue ->
            ( { model | value = newValue }, Cmd.none )

        StoreItem ->
            ( model, setItem { key = model.key, value = model.value } )

        SetKey newKey ->
            ( { model | key = newKey }, Cmd.none )

        SetKeyToGet newKey ->
            ( { model | keyToGet = newKey }, Cmd.none )

        GetItem key ->
            ( model, getItem key )

        GotItem value ->
            ( { model | valueGot = value }, Cmd.none )

        SetKeyToRemove key ->
            ( { model | keyToRemove = key }, Cmd.none )

        RemoveItem ->
            ( model, removeItem model.keyToRemove )

        Clear ->
            ( model, clear () )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "localStorage example" ]
        , div []
            [ h2 [] [ text "Set" ]
            , div []
                [ div []
                    [ label [ for "key-input" ] [ text "Item key" ]
                    , input [ id "key-input", onInput SetKey, value model.key ] []
                    ]
                , div []
                    [ label [ for "value-input" ] [ text "Item value" ]
                    , input [ id "value-input", onInput SetValue, value model.value ] []
                    ]
                , button [ onClick StoreItem ] [ text "Set" ]
                ]
            ]
        , div []
            [ h2 [] [ text "Get" ]
            , div []
                [ label [ for "key-to-get-input" ] [ text "Item key" ]
                , input [ id "key-to-get-input", onInput SetKeyToGet ] []
                , button
                    [ onClick (GetItem model.keyToGet)
                    , disabled (String.length (String.trim model.keyToGet) == 0)
                    ]
                    [ text "Get" ]
                ]
            , div []
                [ label [ for "value-gotten-input" ] [ text " Value gotten" ]
                , input [ id "value-gotten-input", readonly True, value model.valueGot ] []
                ]
            ]
        , div []
            [ h2 [] [ text "Remove" ]
            , div []
                [ label [ for "key-to-remove-input" ] [ text "Item key" ]
                , input [ id "key-to-remove-input", onInput SetKeyToRemove ] []
                , button
                    [ onClick RemoveItem
                    , disabled (String.length (String.trim model.keyToRemove) == 0)
                    ]
                    [ text "Remove" ]
                ]
            ]
        , div []
            [ h2 [] [ text "Clear" ]
            , div []
                [ button
                    [ onClick Clear
                    ]
                    [ text "Clear" ]
                ]
            ]
        ]



-- PORTS


port setItem : LocalStorageItem -> Cmd msg


port getItem : String -> Cmd msg


port gotItem : (String -> msg) -> Sub msg


port removeItem : String -> Cmd msg


port clear : () -> Cmd msg



-- port requestItem : (String -> msg) -> Sub msg
-- port arrivingItem : (String -> msg) -> Sub msg
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    gotItem GotItem
