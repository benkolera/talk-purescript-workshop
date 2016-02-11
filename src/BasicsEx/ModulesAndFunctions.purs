-- You must house your code in a module
module BasicsEx.ModulesAndFunctions where

-- Purescript has no implicit prelude, so even to get basic things 
-- like strings and numbers, you need this import!
-- Importing like this imports everything from this module to use here.
import Prelude
-- https://pursuit.purescript.org/packages/purescript-prelude/0.1.4/docs/Prelude

-- Or we can just import one or more functions in instead.
import Control.Monad.Eff.Console (log)

-- Or we can import them so we have to reference them by name.
import qualified DOM as DOM
-- And even import another module in with the same qualified name.
-- If any names clashed in DOM.Node.Types and DOM, we'd get an error 
-- when we tried to use that function because it is ambiguous which 
-- one of the functions we actually wanted.
import qualified DOM.Node.Types as DOM

-- A value is defined like this.
-- <name> :: <type>
-- Where Int -> Int is a function that takes an int and returns an int.
gimme5 :: Int -> Int
gimme5 x = addStuff x 5 -- We call functions with space separated arguments.

-- There aren't actually functions that take more than one argument.
-- This is actually a function that takes an int and returns (Int -> Int)
addStuff :: Int -> Int -> Int
-- addStuff :: Int -> (Int -> Int)
addStuff a b = a + b

-- So we could have implemented gimme5 like
johnny5 :: Int -> Int
johnny5 = addStuff 5 -- This returns our (Int -> Int) that we needed.

-- This is called currying, and partially applying functions like this to return
-- other functions that can be passed around is really useful!

-- Because there isn't any automatic toString in Purescript, you'll have to 
-- call show on something to turn it into a string. This wont work out of the box
-- on your custom data types, but we'll see how to do that shortly.
-- see https://pursuit.purescript.org/packages/purescript-prelude/0.1.4/docs/Prelude#v:show
intToString :: Int -> String
intToString = show 

-- I'm explicitly not putting a type on this guy so you don't get scared. We'll look at it later.
-- But purescript will happily infer types, so this is all OK!
-- Note, we can ignore a parameter by putting underscore in our function definition.
main _ = log ("Gimme five! " <> (intToString $ gimme5 0))

-- A note on $.
-- Writing (intToString $ gimme5 0)
-- is exactly the same as writing:
-- (intToString (gimme5 0))

