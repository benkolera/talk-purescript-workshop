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

-- FYI : type Render state props action = (action -> EventHandler) -> props -> state -> Array ReactElement -> Array ReactElement
headerRender :: T.Render _ _ _
headerRender raiseAct _ _ _ =
  [ R.h1' [ R.text "Listing Components" ]
  , R.p' 
    [ R.button 
      [ RP.className "btn btn-success"
      ]
      [ R.text "Add Counter" ] 
    ]
  ]

headerSpec :: T.Spec _ _ _ _
headerSpec = T.simpleSpec T.defaultPerformAction headerRender

-- FYI: newtype Spec eff state props action
spec :: T.Spec _ _ _ _
spec = headerSpec

-- | The main method creates the task list component, and renders it to the document body.
main :: forall eff. DOM.Element -> Eff (dom :: DOM.DOM, console :: CONSOLE | eff) Unit
main container = do
  let component = T.createClass spec unit
  R.render (R.createFactory component {}) container
  log "Purescript workshop loaded OK!"
  pure unit
