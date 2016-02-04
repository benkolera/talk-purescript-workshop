module ThermiteEx.Hax where

import Prelude

import Control.Monad.Eff.Exception.Unsafe

todo :: forall a. String -> a
todo s = unsafeThrow $ "TODO: " <> s

