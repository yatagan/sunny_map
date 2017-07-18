port module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Debug exposing (log)
import Json.Decode as Decode exposing (field, string, int, float)
import Task
import Geolocation

-- MODEL

type alias Model =
  { shops: (List Shop)
  , error: String
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
    ( Model [] "", Cmd.none )

-- MESSAGES

type Msg
  = JSReady String
  | BoundsChanged Bounds
  | ShopsNearBy (Result Http.Error (List Shop))
  | RequestLocation
  | GetLocation Geolocation.Location
  | GetLocationFailure
  | SetMapLocation Point

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    JSReady _ ->
      ( model, Cmd.batch [ initJsMap (MapOptions (Point 1.290270 103.851959) 14)
                         , fetchShops
                         , Task.attempt processLocation Geolocation.now
                         ] )

    BoundsChanged bounds ->
      ( model, fetchShops )

    ShopsNearBy (Ok shops) ->
      ( { model | shops = shops }, drawShops shops )

    ShopsNearBy (Err _) ->
      ( model, Cmd.none )

    RequestLocation ->
      ( model, Task.attempt processLocation Geolocation.now)

    GetLocation location ->
      ( { model | error = "" }, centerJsMap ( Point location.latitude location.longitude ) )

    GetLocationFailure ->
      ( { model | error = "Can't get geolocation" } , Cmd.none )

    SetMapLocation location ->
      ( model, centerJsMap location )


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div [style [("color", "red")]] [text model.error]
    , a [href "/shops"] [text "Edit shops"]
    , br [] [], button [onClick RequestLocation] [text "Update location"]
    , button [onClick (SetMapLocation (Point 1.290270 103.851959))] [text "Set fake location"]
    ]

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
port centerJsMap : (Point) -> Cmd msg

-- COMMANDS

fetchShops : Cmd Msg
fetchShops =
  let
    url =
      "/shops.json"

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

-- PRIVATE

processLocation : Result Geolocation.Error Geolocation.Location -> Msg
processLocation result =
  case result of
    Ok location ->
      GetLocation location
    Err _ ->
      GetLocationFailure

-- MAIN

main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
