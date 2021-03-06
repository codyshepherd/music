module Encode exposing (..)

import Json.Encode exposing (encode, Value, string, int, float, bool, list, object)
import Models exposing (Board, Session, Track)


encodeMessage : String -> Int -> Value -> String
encodeMessage clientId messageId payload =
    let
        message =
            object
                [ ( "sourceID", string clientId )
                , ( "messageID", int messageId )
                , ( "payload", payload )
                ]
    in
        encode 0 message


encodeSessionId : Int -> Value
encodeSessionId sessionId =
    object [ ( "sessionID", int sessionId ) ]


encodeSession : Session -> Value
encodeSession session =
    object
        [ ( "session"
          , object
                [ ( "sessionID", int session.id )
                , ( "clients", object [] )
                , ( "tempo", int session.tempo )
                , ( "board", encodeBoard session.board )
                ]
          )
        ]


encodeBoard : Board -> Value
encodeBoard board =
    list (List.map encodeTrack board)


encodeTrack : Track -> Value
encodeTrack track =
    object
        [ ( "trackID", int track.trackId )
        , ( "clientID", string track.clientId )
        , ( "nickname", string track.username )
        , ( "instrument", string track.instrument )
        , ( "grid", list (List.map (\r -> encodeRow r) track.grid) )
        ]


encodeRow : List Int -> Value
encodeRow row =
    list (List.map (\cell -> int cell) row)


encodeNickname : String -> Value
encodeNickname nickname =
    object [ ( "nickname", string nickname ) ]


encodeError : String -> Value
encodeError error =
    object [ ( "error", string error ) ]


encodeTrackRequest : Int -> Int -> Value
encodeTrackRequest sessionId trackId =
    object
        [ ( "sessionID", int sessionId )
        , ( "trackID", int trackId )
        ]


encodeBroadcast : List Int -> Value -> Value
encodeBroadcast selectedSessions track =
    object
        [ ( "track", track )
        , ( "sessionIDs", list (List.map (\id -> int id) selectedSessions) )
        ]
