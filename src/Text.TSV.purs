module Text.TSV (module Text.CSV.Internal, parse, print) where

import Data.Either (Either)
import Data.String (joinWith)
import Prelude (map, ($), (<<<))
import Text.CSV.Internal (CSVType(..), TSV, csvParser, escapeField)
import StringParser (ParseError, runParser)

-- | Read a TSV string to type TSV
parse :: String -> Either ParseError TSV
parse cs =
  runParser (csvParser TabSeparated) cs

-- | Print TSV value into string based on RFC4180
print :: TSV -> String
print tsv =
  joinWith "\r\n" $ map (joinWith "\t" <<< map (escapeField TabSeparated)) tsv
