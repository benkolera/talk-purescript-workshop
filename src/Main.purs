module Main where

import Prelude
import Data.Nullable (toMaybe)
import Data.Maybe
import Control.Monad.Eff
import Control.Monad.Eff.Console
import Control.Alt ((<|>))
import Control.Apply ((*>))

import DOM
import DOM.HTML (window)
import DOM.HTML.Window (document)
import DOM.HTML.Types (htmlDocumentToParentNode)
import DOM.Node.Types as DOM
import DOM.Node.ParentNode (querySelector)

import Routing (matches)
import Routing.Match as R
import Routing.Match.Class (lit)

import ThermiteEx.Intro as ThermiteExIntro
import ThermiteEx.State as ThermiteExState
import ThermiteEx.Actions as ThermiteExActions
import ThermiteEx.Components as ThermiteExComponents
import ThermiteEx.Lists as ThermiteExLists

import BasicsEx.ModulesAndFunctions as BasicsExModulesAndFunctions
import BasicsEx.DataTypes as BasicsExDataTypes

data ThermiteSubRoute = ThermiteIntro | ThermiteState | ThermiteActions | ThermiteComponents | ThermiteLists
data BasicSubRoute = BasicModulesAndFunctions | BasicDataTypes
data Route = ThermiteRoute ThermiteSubRoute | BasicRoute BasicSubRoute

thermiteRouting :: R.Match ThermiteSubRoute
thermiteRouting =
  lit "intro"          *> pure ThermiteIntro
  <|> lit "state"      *> pure ThermiteState
  <|> lit "actions"    *> pure ThermiteActions
  <|> lit "components" *> pure ThermiteComponents
  <|> lit "lists"      *> pure ThermiteLists

basicRouting :: R.Match BasicSubRoute
basicRouting = 
  lit "modules_and_functions" *> pure BasicModulesAndFunctions
  <|> lit "data_types"            *> pure BasicDataTypes

routing :: R.Match Route
routing = 
  ThermiteRoute <$> (lit "thermite" *> thermiteRouting)
  <|> BasicRoute <$> (lit "basics" *> basicRouting)
  <|> pure (ThermiteRoute ThermiteIntro)

handleThermiteRoutes :: DOM.Element -> ThermiteSubRoute -> Eff ( console :: CONSOLE, dom :: DOM ) Unit
handleThermiteRoutes e ThermiteIntro      = ThermiteExIntro.main e
handleThermiteRoutes e ThermiteState      = ThermiteExState.main e
handleThermiteRoutes e ThermiteActions    = ThermiteExActions.main e
handleThermiteRoutes e ThermiteComponents = ThermiteExComponents.main e
handleThermiteRoutes e ThermiteLists      = ThermiteExLists.main e


handleBasicRoutes :: DOM.Element -> BasicSubRoute -> Eff ( console :: CONSOLE, dom :: DOM ) Unit
handleBasicRoutes e BasicModulesAndFunctions = BasicsExModulesAndFunctions.main e
handleBasicRoutes e BasicDataTypes           = BasicsExDataTypes.main e

handleRoutes :: DOM.Element -> Maybe Route -> Route -> Eff ( console :: CONSOLE, dom :: DOM ) Unit
handleRoutes e _ (ThermiteRoute tr) = handleThermiteRoutes e tr
handleRoutes e _ (BasicRoute tr) = handleBasicRoutes e tr

main :: Eff (console :: CONSOLE, dom :: DOM) Unit
main = do
  d    <- window >>= document
  cMay <- toMaybe <$> querySelector "#app" (htmlDocumentToParentNode d)
  case cMay of
       Nothing -> log "ERROR: Cannot find #app in document"
       Just c  -> matches routing (handleRoutes c)
