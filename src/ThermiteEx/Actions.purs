module ThermiteEx.Actions where

import Prelude

import Debug.Trace
import Data.Nullable (toMaybe)

import Control.Monad.Eff
import Control.Monad.Eff.Console

import qualified Thermite as T

import qualified React as R
import qualified React.DOM as R
import qualified React.DOM.Props as RP

import qualified DOM as DOM
import qualified DOM.Node.Types as DOM

type State = Int
data Action = Increment | Decrement

-- FYI : type Render state props action = (action -> EventHandler) -> props -> state -> Array ReactElement -> Array ReactElement
render :: T.Render State _ Action
render raiseAct _ state _ = 
  [ R.p 
    [ RP.className "input-group" ] 
    [ R.span 
      [ RP.className "input-group-btn" ] 
      [ R.button 
        [ RP.className "btn btn-default"
        , RP.onClick \_ -> raiseAct Decrement
        ]
        [ R.text "-" ]
      ] 
    , R.input 
      [ RP.className "form-control"
      , RP._type "text"
      , RP.disabled true
      , RP.value (show state)
      ] []
    , R.span 
      [ RP.className "input-group-btn" ] 
      [ R.button 
        [ RP.className "btn btn-default"
        , RP.onClick \_ -> raiseAct Increment
        ]
        [ R.text "+" ]
      ] 
    ]
  ]

-- FYI: type PerformAction eff state props action = action -> props -> state -> ((state -> state) -> Eff eff Unit) -> Eff eff Unit
-- This is where we'd put things in like an ajax call to the server to update the state. But because eff is still a wildcard,
-- we cannot actually do any effects here (other than calling update, obviously).
performAction :: T.PerformAction _ State _ Action
performAction Increment _ _ update = update $ (+1)
performAction Decrement _ _ update = update $ \s -> (s - 1)

-- FYI: newtype Spec eff state props action
-- The nice thing about this is that the fact that we are doing something with this action,
-- we're still not having any external effects (Ajax, Dom, etc) because eff is still a 
-- wildcard. 
spec :: T.Spec _ State _ Action
spec = T.simpleSpec performAction render

-- The header component
header :: T.Spec _ _ _ _
header = T.simpleSpec T.defaultPerformAction render
  where
  render _ _ _ _ =
    [ R.h1' [ R.text "Modifying the state" ] ]

-- | The main method creates the task list component, and renders it to the document body.
main :: forall eff. DOM.Element -> Eff (dom :: DOM.DOM, console :: CONSOLE | eff) Unit
main container = do
  let component = T.createClass (header <> spec) 42
  -- The properties only come into it outside of thermite. The properties are here and 
  -- typesafe but it means that we're bundling everything into state instead. Is this
  -- OK because we have better ways to reason about where the state changes now? I'm
  -- not sure.
  R.render (R.createFactory component {}) container
  log "Purescript workshop loaded OK!"
  pure unit
