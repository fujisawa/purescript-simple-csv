module Text.CSV (module Text.CSV.Internal, parse, print) where

import Data.Either (Either)
import Data.String (joinWith)
import Prelude (map, ($), (<<<))
import Text.CSV.Internal (CSV, CSVType(..), csvParser, escapeField)
import StringParser (ParseError, runParser)

-- | Read a CSV string to type CSV
parse :: String -> Either ParseError CSV
parse cs =
  runParser (csvParser CommaSeparated) cs

-- | Print CSV value into RFC4180 compliant string
print :: CSV -> String
print csv =
  joinWith "\r\n" $ map (joinWith "," <<< map (escapeField CommaSeparated)) csv
