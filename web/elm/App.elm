port module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Debug exposing (log)
import Json.Decode as Decode exposing (field, string, int, float)


-- MODEL

type alias Model =
  { shops: (List Shop)
  }

type alias Shop =
  { id: Int
  , title: String
  , location: Point
  , description: String
  , infowindow: String
  }

type alias Bounds =
  { east: Float
  , north: Float
  , south: Float
  , west: Float
  }

type alias Point =
  { lat: Float
  , lng: Float
  }

type alias MapOptions =
  { center: Point
  , zoom: Int
  }

init : ( Model, Cmd Msg )
init =
    ( Model [], Cmd.none )

-- MESSAGES

type Msg
  = JSReady String
  | BoundsChanged Bounds
  | ShopsNearBy (Result Http.Error (List Shop))

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case log "update" msg of
    JSReady _ ->
      ( model, Cmd.batch [ initJsMap (MapOptions (Point 1.290270 103.851959) 14)
                         , fetchShops] )

    BoundsChanged bounds ->
      ( model, fetchShops )

    ShopsNearBy (Ok shops) ->
      ( { model | shops = shops }, drawShops shops )

    ShopsNearBy (Err _) ->
      ( model, Cmd.none )

-- VIEW

view : Model -> Html Msg
view model =
  a [href "/admin"] [text "Admin panel"]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ boundsChanged BoundsChanged
    , jsReady JSReady
    , Sub.none
    ]

-- PORTS

port jsReady : (String -> msg) -> Sub msg
port boundsChanged : (Bounds -> msg) -> Sub msg
port initJsMap : (MapOptions) -> Cmd msg
port drawShops : (List Shop) -> Cmd msg

-- COMMANDS

fetchShops : Cmd Msg
fetchShops =
  let
    url =
      "http://localhost:8000/shops.txt"

    request =
      Http.get url decodeShopList
  in
    Http.send ShopsNearBy request

decodePoint : Decode.Decoder Point
decodePoint =
  Decode.map2 Point
    (field "lat" float)
    (field "lng" float)

decodeShop : Decode.Decoder Shop
decodeShop =
  Decode.map5 Shop
    (field "id" int)
    (field "title" string)
    (field "location" decodePoint)
    (field "description" string)
    (field "infowindow" string)

decodeShopList : Decode.Decoder (List Shop)
decodeShopList =
  Decode.list decodeShop

-- MAIN

main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
