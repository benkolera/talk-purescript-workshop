module ThermiteEx.Components where

import Prelude

import Debug.Trace
import Data.Tuple
import Data.Lens
import Data.Either

import Control.Monad.Eff
import Control.Monad.Eff.Console

import qualified Thermite as T

import qualified React as R
import qualified React.DOM as R

import qualified DOM as DOM
import qualified DOM.Node.Types as DOM

import qualified ThermiteEx.Actions as Counter

type State = Tuple Counter.State Counter.State
type Action = Either Counter.Action Counter.Action

-- FYI : type Render state props action = (action -> EventHandler) -> props -> state -> Array ReactElement -> Array ReactElement
render :: T.Render _ _ _
render _ _ _ _ =
  [ R.h1' [ R.text "Combining Components" ]
  ]

-- FYI: newtype Spec eff state props action
spec :: T.Spec _ State _ Action
spec = T.simpleSpec T.defaultPerformAction render 
  -- Do something here to bring in two versions of Counter.Spec with separate state.
  -- See Thermite.focus, and the lenses _1, _2 and the prism _Left _Right

-- | The main method creates the task list component, and renders it to the document body.
main :: forall eff. DOM.Element -> Eff (dom :: DOM.DOM, console :: CONSOLE | eff) Unit
main container = do
  let component = T.createClass spec (Tuple 42 1337)
  R.render (R.createFactory component {}) container
  log "Purescript workshop loaded OK!"
  pure unit
