module ThermiteEx.Intro where

import Prelude

import Debug.Trace

import Control.Monad.Eff
import Control.Monad.Eff.Console

import qualified Thermite as T

import qualified React as R
import qualified React.DOM as R

import qualified DOM as DOM
import qualified DOM.Node.Types as DOM

-- FYI : type Render state props action = (action -> EventHandler) -> props -> state -> Array ReactElement -> Array ReactElement
--
-- Through parametricity we can assert that this render function
-- accesses no state and raises no actions, without even looking
-- at the mess of html building code. Ain't that neat?
render :: T.Render _ _ _
render _ _ _ _ =
  [ R.h1' [ R.text "Purescript Workshop" ]
  , R.p'  [ R.text "Welcome to the purescript workshop!" ]
  , R.p'  [ R.text "Your purescript setup is all OK as this page is being displayed by the stateless component in ThermiteEx.Intro." ]
  ]

-- FYI: newtype Spec eff state props action
--
-- This builds a specification that we can later build a react class out of later.
-- This is even neater, because we can also categorically say that interpreting
-- actions has no global effects either (like doing an AJAX call). 
spec :: T.Spec _ _ _ _
spec = T.simpleSpec T.defaultPerformAction render

-- Hear we're gluing things together up into a react class and setting react up to
-- render it to the DOM (a reference to #app is loaded in Main.purs).
main :: forall eff. DOM.Element -> Eff (dom :: DOM.DOM, console :: CONSOLE | eff) Unit
main container = do
  let component = T.createClass spec unit
  R.render (R.createFactory component {}) container
  log "Purescript workshop loaded OK!"
  pure unit
