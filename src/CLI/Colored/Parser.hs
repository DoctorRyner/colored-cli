module CLI.Colored.Parser where

import           Control.Monad.Combinators
import           Data.Maybe
import           Data.Void
import           System.Console.ANSI
import           Text.Megaparsec
import           Text.Megaparsec.Char

import           CLI.Colored.Types

type Parser = Parsec Void String

color :: Parser Color
color = choice
    [ Red     <$ string "red"
    , Black   <$ string "black"
    , Green   <$ string "green"
    , Yellow  <$ string "yellow"
    , Blue    <$ string "blue"
    , Magenta <$ string "magenta"
    , Cyan    <$ string "cyan"
    , White   <$ string "white"
    ]

coloredText :: Parser Colored
coloredText = do
    maybeEscape <- try $ optional $ char '\\'

    if isJust maybeEscape
    then pure $ Plain ""
    else do
        char '#'
        color <- color
        text  <- between (char '('                   )
                         (char ')'                   )
                         (many $ satisfy (/= ')')    )

        pure $ Colored text color

coloredStep :: Parser [Colored]
coloredStep = do
    (text, maybeColoredText) <- (satisfy (const True)) `someTill_` optional coloredText
    next <- optional coloredStep
    case maybeColoredText of
        Just coloredText -> pure $ [Plain text, coloredText] ++ fromMaybe [] next
        Nothing          -> pure $ [Plain text] ++ fromMaybe [] next

colored :: Parser [Colored]
colored = optional coloredText >>= \case Just coloredText -> ([coloredText] ++) <$> coloredStep
                                         Nothing          -> coloredStep
