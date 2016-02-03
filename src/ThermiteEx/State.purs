module ThermiteEx.State where

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

type State = { number :: Int }

-- FYI : type Render state props action = (action -> EventHandler) -> props -> state -> Array ReactElement -> Array ReactElement
render :: T.Render State _ _
render _ _ state _ = 
  [ R.h1' [ R.text "Rendering State" ]
  , R.p'  [ R.text "The answer is " , R.text $ show state.number ]
  ]

-- FYI: newtype Spec eff state props action
spec :: T.Spec _ State _ _
spec = T.simpleSpec T.defaultPerformAction render

-- | The main method creates the task list component, and renders it to the document body.
main :: forall eff. DOM.Element -> Eff (dom :: DOM.DOM, console :: CONSOLE | eff) Unit
main container = do
  let component = T.createClass spec { number: 42  }
  -- The properties only come into it outside of thermite. The properties are here and 
  -- typesafe but it means that we're bundling everything into state instead. Is this
  -- OK because we have better ways to reason about where the state changes now? I'm
  -- not sure.
  R.render (R.createFactory component {}) container
  log "Purescript workshop loaded OK!"
  pure unit
