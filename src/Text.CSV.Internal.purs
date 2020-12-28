module Text.CSV.Internal (CSV, TSV, CSVType(..), csvParser, escapeField) where

import Control.MonadPlus ((<|>))
import Data.Array (dropEnd, fromFoldable, head, many, reverse, (:))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String (Pattern(..), Replacement(..), replaceAll)
import Data.String.CodeUnits (fromCharArray)
import Data.String.Regex (test)
import Data.String.Regex.Flags (noFlags)
import Data.String.Regex.Unsafe (unsafeRegex)
import Prelude (Unit, bind, discard, pure, unit, void, ($), (<$>), (<*>), (<>))
import Text.Parsing.StringParser (Parser)
import Text.Parsing.StringParser.CodeUnits (anyChar, char, noneOf, oneOf)
import Text.Parsing.StringParser.Combinators (optionMaybe, optional, sepBy, sepBy1)

type CSV = Array (Array String)
type TSV = CSV

data CSVType = CSVtype | TSVtype

csvParser :: CSVType -> Parser CSV
csvParser csvType = do
  x <- fromFoldable <$> sepBy1 recordParser newline
  case head $ reverse x of
    Just [""] -> pure $ dropEnd 1 x
    otherwise -> pure x
  where
    recordParser :: Parser (Array String)
    recordParser = fromFoldable <$> sepBy fieldParser (char separator)

    separator = case csvType of
      CSVtype -> ','
      TSVtype -> '\t'

    fieldParser :: Parser String
    fieldParser = getEscaped <|> getNonescaped

    getNonescaped:: Parser String
    getNonescaped = do
      fromCharArray <$> (many $ noneOf [separator, '\r', '\n'])


getEscaped :: Parser String
getEscaped = do
  void $ char '"'
  fromCharArray <$> getRest
  where getRest = do
          a <- anyChar
          case a of
            '"' -> fromMaybe [] <$> optionMaybe ((:) <$> char '"' <*> getRest)
            otherwise -> (:) a <$> getRest

newline :: Parser Unit
newline = do
  a <- oneOf ['\r', '\n']
  case a of
    '\r' -> optional $ char '\n'
    _ -> pure unit

escapeField :: CSVType -> String -> String
escapeField csvType s =
  if test (unsafeRegex separator noFlags) s
  then quote $ replaceAll (Pattern "\"") (Replacement "\"\"") s
  else s
  where quote s' =
          "\"" <> s' <> "\""
        separator = case csvType of
          CSVtype -> "(,|\"|\n)"
          TSVtype -> "(\t|\"|\n)"
