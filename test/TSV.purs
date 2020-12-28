module Test.TSV where

import Prelude

import Data.Either (Either(..))
import Effect (Effect)
import Test.Assert (assertEqual)
import Text.TSV as TSV

main :: Effect Unit
main = do
  assertEqual { actual: TSV.parse "e1-1"
              , expected: Right [["e1-1"]]
              }
  assertEqual { actual: TSV.parse "\"e1-1\""
              , expected: Right [["e1-1"]]
              }
  assertEqual { actual: TSV.parse "\"e1-1\t\""
              , expected: Right [["e1-1\t"]]
              }
  assertEqual { actual: TSV.parse "\"e1-1\"\"\""
              , expected: Right [["e1-1\""]]
              }
  assertEqual { actual: TSV.parse "\"e1-1\ne1-1-2\""
              , expected: Right [["e1-1\ne1-1-2"]]
              }
  assertEqual { actual: TSV.parse "e1-1\te1-2\te1-3"
              , expected: Right [["e1-1", "e1-2", "e1-3"]]
              }
  assertEqual { actual: TSV.parse "e1-1\te1-2\te1-3\n"
              , expected: Right [["e1-1", "e1-2", "e1-3"]]
              }
  assertEqual { actual: TSV.parse "e1-1\te1-2\te1-3\r"
              , expected: Right [["e1-1", "e1-2", "e1-3"]]
              }
  assertEqual { actual: TSV.parse "e1-1\te1-2\te1-3\r\n"
              , expected: Right [["e1-1", "e1-2", "e1-3"]]
              }
  assertEqual { actual: TSV.parse "e1-1\te1-2\te1-3\ne2-1\te2-2\te2-3"
              , expected: Right [["e1-1", "e1-2", "e1-3"], ["e2-1", "e2-2", "e2-3"]]
              }
  assertEqual { actual: TSV.parse "e1-1\te1-2\te1-3\re2-1\te2-2\te2-3"
              , expected: Right [["e1-1", "e1-2", "e1-3"], ["e2-1", "e2-2", "e2-3"]]
              }
  assertEqual { actual: TSV.parse "e1-1\te1-2\te1-3\r\ne2-1\te2-2\te2-3"
              , expected: Right [["e1-1", "e1-2", "e1-3"], ["e2-1", "e2-2", "e2-3"]]
              }
  assertEqual { actual: TSV.parse ""
              , expected: Right []
              }
  assertEqual { actual: TSV.parse "e1-1\t\"e1-2\ne1-2-2\"\te1-3\r\ne2-1\te2-2\te2-3"
              , expected: Right [["e1-1", "e1-2\ne1-2-2", "e1-3"], ["e2-1", "e2-2", "e2-3"]]
              }
  assertEqual { actual: TSV.print <$> TSV.parse "e1-1"
              , expected: Right "e1-1"
              }
  assertEqual { actual: TSV.print <$> TSV.parse "\"e1-1\""
              , expected: Right "e1-1"
              }
  assertEqual { actual: TSV.print <$> TSV.parse "\"e1-1\t\""
              , expected: Right "\"e1-1\t\""
              }
  assertEqual { actual: TSV.print <$> TSV.parse "\"e1-1\"\"\""
              , expected: Right "\"e1-1\"\"\""
              }
  assertEqual { actual: TSV.print <$> TSV.parse "\"e1-1\ne1-1-2\""
              , expected: Right "\"e1-1\ne1-1-2\""
              }
