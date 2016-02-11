module BasicsEx.DataTypes where

import Prelude
import Control.Monad.Eff.Console (log)

-- NOTE: Please ensure that you've read the basic readme section on this chapter! :)

-- We can define the type ErrMsg with a single constructor of the same name
data ErrMsg = ErrMsg Number String

-- But then the only way we can extract the values out of those is via pattern matching
getErrMsg :: ErrMsg -> String
getErrMsg (ErrMsg _ m) = m

-- Which is pretty annoying, and it's in a structure that doesn't translate to JS well.
-- A record is simply a bunch of fields defined with { <name> :: String } syntax.
-- A record is constructed with special syntax { name: val } and the record is a type
-- in it's own right, so we just alias that type with a name we can use later.
-- instead with type (note: type vs data).
type ErrMsgRecord = 
  { code :: Number
  , msg  :: String
  }

-- And then we can just grab things out with a dot.
getErrMsg2 :: ErrMsgRecord -> String
getErrMsg2 e = e.msg

-- And it also comes with great syntax for updates. Note the record is immutable
-- and returns a new record!
setErrMsg :: ErrMsgRecord -> String -> ErrMsgRecord
setErrMsg e s = e { msg = s }

testErrMsg = ErrMsg 1.0 "Broken"
testErrMsgRecord = { 
  code: 1.0,
  msg: "borked"
}

-- A sum type has multiple constructors
data PossiblyWrong = Broken ErrMsgRecord | Ok String

-- You can construct it with it's constructors like normal
actuallyWrong :: PossiblyWrong
actuallyWrong = Broken testErrMsgRecord

notWrong :: PossiblyWrong
notWrong = Ok "ALL GOOD"

-- And then we can pattern match this:
possiblyWrongToString :: PossiblyWrong -> String
possiblyWrongToString (Broken err) = "ERROR: " <> err.msg
possiblyWrongToString (Ok s)       = "OK:    " <> s

main _ = do
  log $ "getErrMsg: " <> getErrMsg testErrMsg
  log $ "getErrMsgChanged: " <> getErrMsg2 (setErrMsg testErrMsgRecord "other err")
  -- Note the original message is unchanged
  log $ "getErrMsg: " <> getErrMsg2 testErrMsgRecord
  log $ "actuallyWrong: " <> possiblyWrongToString actuallyWrong 
  log $ "notWrong: " <> possiblyWrongToString notWrong 
