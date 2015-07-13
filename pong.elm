import Time exposing (Time)
import Text exposing (fromString)
import Graphics.Element exposing (..)

type alias Input =
  { space: Bool
  , paddle1: Int
  , paddle2: Int
  , delta: Time }

main = fromString "Hello World"
  |> leftAligned
