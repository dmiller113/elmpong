import Time exposing (Time, inSeconds, fps, second)
import Text exposing (fromString, Text)
import Graphics.Element exposing (..)
import Keyboard
import Signal exposing (..)

--inputs for the game. Space acts as a pause.
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

(gameWidth, gameHeight) = (600, 400)
(halfWidth, halfHeight) = (300, 200)

type alias Object a =
  { a |
     x: Float,
     y: Float,
    vx: Float,
    vy: Float
  }

type alias Ball =
  Object {}

type alias Player =
  Object { score : Int }

type State = Pause | Play

type alias Game =
  {
    state:   State,
    ball:    Ball,
    player1: Player,
    player2: Player
  }

player: Float -> Player
player x =
  {
    x=x, y=0, vx=0, vy=0, score=0
  }

defaultGame: Game
defaultGame =
  {
    state   = Pause,
    ball    = {x=0, y=0, vx=200, vy=200},
    player1 = player (20-halfWidth),
    player2 = player (halfWidth-20)
  }

-- Helper Functions

-- near: Is n within c of m
near: Float -> Float -> Float -> Bool
near n c m =
  n >= m - c && n <= m + c

-- within: is the ball inside a paddle?
within: Ball -> Player -> Bool
within ball paddle =
  near ball.x 8 paddle.x &&
    near ball.y 20 paddle.y

-- stepV: change velocity based on where it collided

-- Things for temp display
defaultMessage: String
defaultMessage = "neutral"

inputToMessage: Input -> Text
inputToMessage input =
  if | input.paddle1 ==  1 -> fromString "Up"
     | input.paddle1 == -1 -> fromString "Down"
     | otherwise           -> fromString defaultMessage

main =
  inputToMessage <~ input
    |> Signal.map leftAligned
