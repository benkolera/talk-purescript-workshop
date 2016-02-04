module ThermiteEx.Intro where

import Prelude

import Control.Monad.Eff
import Control.Monad.Eff.Console

import qualified Thermite as T

import qualified React as R
import qualified React.DOM as R

import qualified DOM as DOM
import qualified DOM.Node.Types as DOM

-- Render function is much like react. Take the props, state and give some HTML back.
--
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

-- Spec is a description of something that can be turned into a react class.
-- It has a base effect (eff), a state, and a type describing the action.
--
-- FYI: newtype Spec eff state props action
--
-- In this case, it means that we don't care about the types of the eff/state/action
-- so this component cannot do anything with those and just render text.
--
-- So we know this thing isn't going to do an ajax call, sneakily toy with the Dom, etc.
--
-- DefaultPerformAction is just a noop.
spec :: T.Spec _ _ _ _
spec = T.simpleSpec T.defaultPerformAction render

-- Hear we're gluing things together up into a react class and setting react up to
-- render it to the DOM (a reference to #app is loaded in Main.purs).
main :: forall eff. DOM.Element -> Eff (dom :: DOM.DOM, console :: CONSOLE | eff) Unit
main container = do
  -- Create a react class from our spec
  let component = T.createClass spec unit
  -- Create the factory and pass it to reacts render method to kick everything off.
  R.render (R.createFactory component {}) container
  log "Purescript workshop loaded OK!"
  pure unit
