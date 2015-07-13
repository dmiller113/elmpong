import Time exposing (Time, inSeconds, fps, second)
import Text exposing (fromString, Text)
import Graphics.Element exposing (..)
import Keyboard
import Signal exposing (..)
{-
  inputs for the game. Space acts as a pause.
-}
type alias Input =
  { space: Bool
  , paddle1: Int
  , paddle2: Int
  , delta: Time }

delta: Signal Time
delta =
  Signal.map inSeconds (fps 35)

input: Signal Input
input =
  Signal.map4 Input
    Keyboard.space
    (Signal.map .y Keyboard.wasd)
    (Signal.map .y Keyboard.arrows)
    delta
  |> Signal.sampleOn delta

defaultMessage: String
defaultMessage = "Hello World"

inputToMessage: Input -> Text
inputToMessage input =
  if | input.paddle1 ==  1 -> fromString "Up"
     | input.paddle1 == -1 -> fromString "Down"
     | otherwise           -> fromString defaultMessage

main =
  inputToMessage <~ input
    |> Signal.map leftAligned
