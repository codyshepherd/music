module Styles exposing (..)

import Color
import Element.Attributes exposing (inlineStyle)
import Style exposing (..)
import Style.Border as Border
import Style.Color as Color
import Style.Font as Font
import Style.Transition as Transition


type Styles
    = ActiveButton
    | Button
    | ErrorMessage
    | ExtendHandle
    | Field
    | GridBlock
    | GridBlockHeld
    | InstrumentField
    | InstrumentLabel
    | Logo
    | Main
    | MenuChoiceFocused
    | MenuChoiceIdle
    | MenuChoiceSelected
    | MenuChoiceSelectedInBox
    | MessageInput
    | Navigation
    | NavOption
    | None
    | PlayOrange
    | PlayPurple
    | Rest
    | RowLabel
    | SelectedSessionButton
    | ServerMessage
    | SessionButton
    | SmallHeading
    | SubHeading
    | SubMenu
    | SuccessMessage
    | Text


serif =
    [ Font.importUrl
        { url = "https://fonts.googleapis.com/css?family=Cinzel"
        , name = "Cinzel"
        }
    , Font.font "times new roman"
    , Font.font "times"
    , Font.font "serif"
    ]


sansSerif =
    [ Font.importUrl
        { url = "https://fonts.googleapis.com/css?family=Quattrocento+Sans"
        , name = "Quattrocento Sans"
        }
    , Font.font "helvetica"
    , Font.font "arial"
    , Font.font "sans-serif"
    ]


noSelect =
    inlineStyle
        [ ( "-webkit-touch-callout", "none" )
        , ( "-webkit-user-select", "none" )
        , ( "-khtml-user-select", "none" )
        , ( "-moz-user-select", "none" )
        , ( "-ms-user-select", "none" )
        , ( "user-select", "none" )
        ]


stylesheet : StyleSheet Styles variation
stylesheet =
    Style.styleSheet
        [ style ActiveButton
            [ Border.all 2
            , Border.rounded 3
            , Color.background (Color.rgb 40 40 40)
            , Color.border (Color.rgb 192 78 17)
            , hover [ Color.border (Color.rgb 230 93 20) ]
            , Color.text Color.white
            , Transition.all
            ]
        , style Button
            [ Border.all 2
            , Border.rounded 3
            , Color.background (Color.rgb 40 40 40)
            , Color.border (Color.rgb 91 96 115)
            , hover [ Color.border (Color.rgb 112 118 143) ]
            , Color.text Color.white
            , Transition.all
            ]
        , style ErrorMessage
            [ Font.size 18
            , Font.letterSpacing 0.45
            , Color.text (Color.rgb 220 0 0)
            ]
        , style ExtendHandle [ cursor "e-resize" ]
        , style Field
            [ Border.all 2
            , Border.rounded 3
            , Color.background (Color.rgb 40 40 40)
            , Color.border (Color.rgb 91 96 115)
            ]
        , style GridBlock [ Color.background (Color.rgb 120 120 120) ]
        , style GridBlockHeld
            [ Color.background (Color.rgb 120 120 120)
            , cursor "pointer"
            ]
        , style InstrumentField
            [ Color.text Color.white
            , Font.size 16
            , Font.letterSpacing 0.45
            ]
        , style InstrumentLabel [ Font.size 20 ]
        , style Logo
            [ Font.typeface serif
            , Font.size 36
            ]
        , style Main
            [ Color.background (Color.rgb 40 40 40)
            , Color.text Color.white
            , Font.typeface sansSerif
            ]
        , style MenuChoiceFocused
            [ Color.background (Color.rgb 40 40 40) ]
        , style MenuChoiceIdle
            [ Color.background (Color.rgb 40 40 40) ]
        , style MenuChoiceSelected
            [ Color.background (Color.rgb 210 210 210)
            , Color.text Color.black
            ]
        , style MenuChoiceSelectedInBox
            [ Color.background (Color.rgb 40 40 40) ]
        , style MessageInput
            [ Border.all 2
            , Border.rounded 3
            , Color.background (Color.rgb 40 40 40)
            , Color.border (Color.rgb 75 79 94)
            , Color.text Color.white
            ]
        , style Navigation
            [ Border.bottom 1
            , Color.background (Color.rgb 39 39 39)
            , Color.border (Color.rgb 28 31 36)
            , Color.text Color.white
            ]
        , style NavOption
            [ Font.typeface sansSerif
            , Font.size 18
            , hover [ Color.text (Color.rgb 200 200 200) ]
            , Transition.all
            ]
        , style None []
        , style PlayOrange
            [ Color.background (Color.rgb 215 88 19)
            ]
        , style PlayPurple
            [ Color.background (Color.rgb 91 96 115)
            ]
        , style Rest
            [ Color.background (Color.rgb 150 150 150)
            ]
        , style RowLabel
            [ Color.background (Color.rgb 40 40 40)
            , Color.text (Color.rgb 160 160 160)
            , Font.size 10
            ]
        , style SelectedSessionButton
            [ Border.all 2
            , Border.rounded 3
            , Color.background (Color.rgb 192 78 17)
            , Color.border (Color.rgb 192 78 17)
            , Color.text Color.white
            , Transition.all
            ]
        , style ServerMessage
            [ Font.size 18
            , Color.text (Color.rgb 215 88 19)
            ]
        , style SessionButton
            [ Border.all 2
            , Border.rounded 3
            , Color.background (Color.rgb 66 69 82)
            , Color.border (Color.rgb 66 69 82)
            , Color.text Color.white
            , Transition.all
            ]
        , style SmallHeading
            [ Font.typeface serif
            , Font.size 18
            ]
        , style SubHeading
            [ Font.typeface serif
            , Font.size 24
            ]
        , style SubMenu
            [ Font.size 11
            ]
        , style SuccessMessage
            [ Font.size 18
            , Font.letterSpacing 0.45
            , Color.text Color.green
            ]
        , style Text
            [ Font.size 18
            , Font.letterSpacing 0.45
            ]
        ]



-- Color.rgb 28 31 36
-- Color.rgb 171 0 0
