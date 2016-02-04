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

import ThermiteEx.Hax

type State = Int
data Action = Increment | Decrement

-- FYI : type Render state props action = (action -> EventHandler) -> props -> state -> Array ReactElement -> Array ReactElement
-- Note, the first array of spans,buttons, divs are the attributes.
render :: T.Render State _ Action
render raiseAct _ state _ = 
  [ R.p 
    [ RP.className "input-group" ] 
    [ R.span 
      [ RP.className "input-group-btn" ] 
      [ R.button 
        [ RP.className "btn btn-default" ]
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
        [ RP.className "btn btn-default" ]
        [ R.text "+" ]
      ] 
    ]
  ]

-- FYI: type PerformAction eff state props action = action -> props -> state -> ((state -> state) -> Eff eff Unit) -> Eff eff Unit
-- This is where we'd put things in like an ajax call to the server to update the state. We don't need to do that now though.
performAction :: T.PerformAction _ State _ Action
performAction _ _ _ _ = pure unit -- TODO: <--- Implement me!!

-- FYI: newtype Spec eff state props action
-- The nice thing about this is that the fact that we are doing something with this action,
-- we're still not having any external effects (Ajax, Dom, etc) because eff is still a 
-- wildcard. 
--
-- We're going to reuse this bit in later exercises which is why things are separate.
spec :: T.Spec _ State _ Action
spec = T.simpleSpec performAction render

-- The header component So 
headerSpec :: T.Spec _ _ _ _
headerSpec = T.simpleSpec T.defaultPerformAction render'
  where
  render' _ _ _ _ =
    [ R.h1' [ R.text "Modifying the state" ] ]

-- Note that we can combine specs together with Prelude.(<>) / append because it is a semigroup
fullSpec :: T.Spec _ State _ Action
fullSpec = headerSpec <> spec

-- | The main method creates the task list component, and renders it to the document body.
main :: forall eff. DOM.Element -> Eff (dom :: DOM.DOM, console :: CONSOLE | eff) Unit
main container = do
  let component = T.createClass fullSpec 42
  -- The properties only come into it outside of thermite. The properties are here and 
  -- typesafe but it means that we're bundling everything into state instead. Is this
  -- OK because we have better ways to reason about where the state changes now? I'm
  -- not sure.
  R.render (R.createFactory component {}) container
  log "Purescript workshop loaded OK!"
  pure unit
