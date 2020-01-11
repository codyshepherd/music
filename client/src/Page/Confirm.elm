module Page.Confirm exposing (Model, Msg(..), init, subscriptions, update, view)

import Api
import Browser.Navigation as Nav exposing (pushUrl)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (..)
import Element.Font as Font
import Element.Input as Input
import Fonts
import Html.Events exposing (on)
import Json.Decode as Decode
import Json.Encode as Encode
import Session exposing (Session)


type alias Model =
    { session : Session
    , problems : List Problem
    , form : Form
    }


type Problem
    = InvalidEntry ValidatedField String
    | AuthProblem String


type alias Form =
    { username : String
    , confirmationCode : String
    }


init : Session -> ( Model, Cmd msg )
init session =
    ( { session = session
      , problems = []
      , form =
            { username = ""
            , confirmationCode = ""
            }
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SubmittedForm
    | EnteredUsername String
    | EnteredConfirmationCode String
    | CompletedConfirmation (Result Api.AuthError Api.AuthSuccess)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmittedForm ->
            case validate model.form of
                Ok (Trimmed form) ->
                    ( { model | problems = [] }
                    , confirm form
                    )

                Err problems ->
                    ( { model | problems = problems }
                    , Cmd.none
                    )

        EnteredUsername newUsername ->
            updateForm (\form -> { form | username = newUsername }) model

        EnteredConfirmationCode newConfirmationCode ->
            updateForm (\form -> { form | confirmationCode = newConfirmationCode }) model

        CompletedConfirmation (Err error) ->
            case error of
                Api.AuthError err ->
                    ( { model | problems = AuthProblem err :: model.problems }, Cmd.none )

                Api.DecodeError _ ->
                    ( { model
                        | problems = AuthProblem "An internal decoding error occured. Please contact the developers." :: model.problems
                      }
                    , Cmd.none
                    )

        CompletedConfirmation (Ok _) ->
            ( model, Nav.pushUrl (Session.navKey model.session) "login" )


updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm transform model =
    ( { model | form = transform model.form }, Cmd.none )



-- VIEW


view : Model -> Element Msg
view model =
    row [ centerX, width fill, paddingXY 0 150, Font.family Fonts.quattrocentoFont ]
        [ column [ centerX, width (px 375), spacing 25 ]
            [ row [ centerX ] [ el [ Font.family Fonts.cinzelFont, Font.size 27 ] <| text "Confirm your registration" ]
            , row
                [ centerX
                , paddingXY 0 25
                , width fill
                , Background.color (rgba 0.2 0.2 0.2 1)
                , Border.color (rgba 0.36 0.38 0.45 0.1)
                , Border.rounded 3
                , Border.width 1
                ]
                [ column [ centerX, width (px 300), spacing 20 ]
                    [ Input.username
                        [ onEnter SubmittedForm, spacing 12, Font.color (rgba 0 0 0 1) ]
                        { text = model.form.username
                        , placeholder = Nothing
                        , onChange = \newUsername -> EnteredUsername newUsername
                        , label = Input.labelAbove [ alignLeft, Font.size 18, Font.color (rgba 1 1 1 1) ] (text "Username")
                        }
                    , Input.text
                        [ onEnter SubmittedForm, spacing 12, Font.color (rgba 0 0 0 1) ]
                        { text = model.form.confirmationCode
                        , placeholder = Nothing
                        , onChange = \newConfirmationCode -> EnteredConfirmationCode newConfirmationCode
                        , label = Input.labelAbove [ alignLeft, Font.size 18, Font.color (rgba 1 1 1 1) ] (text "Confirmation Code")
                        }
                    , Input.button
                        [ Border.color (rgba 0.36 0.38 0.45 1)
                        , mouseOver [ Border.color (rgba 0.42 0.44 0.51 1) ]
                        , paddingXY 32 16
                        , Border.rounded 3
                        , Border.width 2
                        , width fill
                        ]
                        { onPress = Just SubmittedForm
                        , label = el [ centerX ] <| text "Confirm"
                        }
                    ]
                ]
            , row [ centerX ]
                [ column [] (List.map viewProblem model.problems)
                ]
            ]
        ]


viewProblem : Problem -> Element msg
viewProblem problem =
    let
        errorMessage =
            case problem of
                InvalidEntry _ error ->
                    error

                AuthProblem error ->
                    error
    in
    row [ centerX, paddingXY 0 5 ] [ el [ Font.size 18 ] <| text errorMessage ]


onEnter : msg -> Element.Attribute msg
onEnter msg =
    Element.htmlAttribute <|
        Html.Events.on "keyup"
            (Decode.field "key" Decode.string
                |> Decode.andThen
                    (\key ->
                        if key == "Enter" then
                            Decode.succeed msg

                        else
                            Decode.fail "Not the enter key"
                    )
            )



-- SUBSCRIPTIONS


subscriptions : Sub Msg
subscriptions =
    Api.authResponse (\authResult -> CompletedConfirmation authResult)



-- FORM


type TrimmedForm
    = Trimmed Form


type ValidatedField
    = Username
    | ConfirmationCode


fieldsToValidate : List ValidatedField
fieldsToValidate =
    [ Username
    , ConfirmationCode
    ]


{-| Trim the form and validate its fields. If there are problems, report them!
-}
validate : Form -> Result (List Problem) TrimmedForm
validate form =
    let
        trimmedForm =
            trimFields form
    in
    case List.concatMap (validateField trimmedForm) fieldsToValidate of
        [] ->
            Ok trimmedForm

        problems ->
            Err problems


validateField : TrimmedForm -> ValidatedField -> List Problem
validateField (Trimmed form) field =
    List.map (InvalidEntry field) <|
        case field of
            Username ->
                if String.isEmpty form.username then
                    [ "Username can't be blank." ]

                else
                    []

            ConfirmationCode ->
                if String.isEmpty form.confirmationCode then
                    [ "Cofirmation code can't be blank." ]

                else
                    []


trimFields : Form -> TrimmedForm
trimFields form =
    Trimmed
        { username = String.trim form.username
        , confirmationCode = String.trim form.confirmationCode
        }



-- AUTH


confirm : Form -> Cmd msg
confirm form =
    let
        json =
            Encode.object
                [ ( "username", Encode.string form.username )
                , ( "code", Encode.string form.confirmationCode )
                ]
    in
    Api.confirm json