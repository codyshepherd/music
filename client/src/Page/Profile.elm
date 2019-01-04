module Page.Profile exposing (Model, Msg(..), init, update, view)

import Element exposing (..)
import Element.Events exposing (..)
import Element.Font as Font
import Element.Input as Input
import Fonts


type alias Model =
    Int


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( model + 1, Cmd.none )

        Decrement ->
            ( model - 1, Cmd.none )



-- VIEW


view : Model -> Element Msg
view model =
    row [ centerX, width fill, paddingXY 0 10 ]
        [ column [ centerX, spacing 10, Font.family Fonts.quattrocentoFont ]
            [ text "Viewing the profile page"
            , row [ width fill ]
                [ column [ centerX ]
                    [ Input.button [ centerX ] { onPress = Just Increment, label = text "+" }
                    , el [ centerX ] <| text (String.fromInt model)
                    , Input.button [ centerX ] { onPress = Just Decrement, label = text "-" }
                    ]
                ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
