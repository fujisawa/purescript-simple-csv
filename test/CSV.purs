module Test.CSV where

import Prelude

import Data.Either (Either(..))
import Effect (Effect)
import Test.Assert (assertEqual)
import Text.CSV as CSV

main :: Effect Unit
main = do
  assertEqual { actual: CSV.parse "e1-1"
              , expected: Right [["e1-1"]]
              }
  assertEqual { actual: CSV.parse "\"e1-1\""
              , expected: Right [["e1-1"]]
              }
  assertEqual { actual: CSV.parse "\"e1-1,\""
              , expected: Right [["e1-1,"]]
              }
  assertEqual { actual: CSV.parse "\"e1-1\"\"\""
              , expected: Right [["e1-1\""]]
              }
  assertEqual { actual: CSV.parse "\"e1-1\ne1-1-2\""
              , expected: Right [["e1-1\ne1-1-2"]]
              }
  assertEqual { actual: CSV.parse "e1-1,e1-2,e1-3"
              , expected: Right [["e1-1", "e1-2", "e1-3"]]
              }
  assertEqual { actual: CSV.parse "e1-1,e1-2,e1-3\n"
              , expected: Right [["e1-1", "e1-2", "e1-3"]]
              }
  assertEqual { actual: CSV.parse "e1-1,e1-2,e1-3\r"
              , expected: Right [["e1-1", "e1-2", "e1-3"]]
              }
  assertEqual { actual: CSV.parse "e1-1,e1-2,e1-3\r\n"
              , expected: Right [["e1-1", "e1-2", "e1-3"]]
              }
  assertEqual { actual: CSV.parse "e1-1,e1-2,e1-3\ne2-1,e2-2,e2-3"
              , expected: Right [["e1-1", "e1-2", "e1-3"], ["e2-1", "e2-2", "e2-3"]]
              }
  assertEqual { actual: CSV.parse "e1-1,e1-2,e1-3\re2-1,e2-2,e2-3"
              , expected: Right [["e1-1", "e1-2", "e1-3"], ["e2-1", "e2-2", "e2-3"]]
              }
  assertEqual { actual: CSV.parse "e1-1,e1-2,e1-3\r\ne2-1,e2-2,e2-3"
              , expected: Right [["e1-1", "e1-2", "e1-3"], ["e2-1", "e2-2", "e2-3"]]
              }
  assertEqual { actual: CSV.parse ""
              , expected: Right []
              }
  assertEqual { actual: CSV.parse "e1-1,\"e1-2\ne1-2-2\",e1-3\r\ne2-1,e2-2,e2-3"
              , expected: Right [["e1-1", "e1-2\ne1-2-2", "e1-3"], ["e2-1", "e2-2", "e2-3"]]
              }
  assertEqual { actual: CSV.print <$> CSV.parse "e1-1"
              , expected: Right "e1-1"
              }
  assertEqual { actual: CSV.print <$> CSV.parse "\"e1-1\""
              , expected: Right "e1-1"
              }
  assertEqual { actual: CSV.print <$> CSV.parse "\"e1-1,\""
              , expected: Right "\"e1-1,\""
              }
  assertEqual { actual: CSV.print <$> CSV.parse "\"e1-1\"\"\""
              , expected: Right "\"e1-1\"\"\""
              }
  assertEqual { actual: CSV.print <$> CSV.parse "\"e1-1\ne1-1-2\""
              , expected: Right "\"e1-1\ne1-1-2\""
              }
