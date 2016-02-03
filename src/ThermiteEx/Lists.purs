module ThermiteEx.Lists where

import Prelude

import Debug.Trace
import Data.Tuple
import Data.List as L
import Data.Maybe
import Data.Lens
import Data.Either

import Control.Monad.Eff
import Control.Monad.Eff.Console

import qualified Thermite as T

import qualified React as R
import qualified React.DOM as R
import qualified React.DOM.Props as RP

import qualified DOM as DOM
import qualified DOM.Node.Types as DOM

import qualified ThermiteEx.Actions as Counter

type State = L.List Counter.State
data Action = AddCounter | CounterAction Int Counter.Action

-- FYI : type Render state props action = (action -> EventHandler) -> props -> state -> Array ReactElement -> Array ReactElement
headerRender :: T.Render _ _ Action
headerRender raiseAct _ _ _ =
  [ R.h1' [ R.text "Listing Components" ]
  , R.p' 
    [ R.button 
      [ RP.className "btn btn-success"
      , RP.onClick \_ -> raiseAct AddCounter 
      ]
      [ R.text "Add Counter" ] 
    ]
  ]

_CounterAction :: PrismP Action (Tuple Int Counter.Action)
_CounterAction = prism' (uncurry CounterAction) unwrap
  where
  unwrap (CounterAction i a) = Just (Tuple i a)
  unwrap _ = Nothing

-- FYI: type PerformAction eff state props action = action -> props -> state -> ((state -> state) -> Eff eff Unit) -> Eff eff Unit
headerPerformAction :: T.PerformAction _ State _ Action
headerPerformAction AddCounter _ s update     = update $ flip L.snoc 0
headerPerformAction (CounterAction _ _) _ _ _ = pure unit

headerSpec :: T.Spec _ State _ Action
headerSpec = T.simpleSpec headerPerformAction headerRender

-- FYI: newtype Spec eff state props action
spec :: T.Spec _ State _ Action
spec = headerSpec
  <> T.focus id _CounterAction (T.foreach \_ -> Counter.spec)

-- | The main method creates the task list component, and renders it to the document body.
main :: forall eff. DOM.Element -> Eff (dom :: DOM.DOM, console :: CONSOLE | eff) Unit
main container = do
  let component = T.createClass spec L.Nil
  R.render (R.createFactory component {}) container
  log "Purescript workshop loaded OK!"
  pure unit
