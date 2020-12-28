module Test.Main where

import Effect (Effect)
import Prelude (Unit, discard)
import Test.CSV as Test.CSV
import Test.TSV as Test.TSV

main :: Effect Unit
main = do
  Test.CSV.main
  Test.TSV.main
