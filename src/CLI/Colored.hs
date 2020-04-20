module CLI.Colored (putStr, putStrLn, print) where

import           Prelude             hiding (print, putStr, putStrLn)
import qualified Prelude

import           System.Console.ANSI
import           Text.Megaparsec

import           CLI.Colored.Parser
import           CLI.Colored.Types

put :: String -> Color -> IO ()
put text color = do
    setSGR [SetColor Foreground Vivid color]
    Prelude.putStr text
    setSGR [Reset]

-- | Write a string to the standard output device with ansi colors support. You can use next colors: red, black, green, yellow, blue, magenta, cyan and white
--
-- ==== __Examples__
--
-- >>> putStr "Hello"
-- Hello
--
-- >>> putStr "#red(Hello)"
-- Hello
--
-- But this time `Hello` will be red
--
-- >>> putStr "Hello, #black(this) will be #blue(blue)"
-- Hello, this will be blue
--
-- A word `this` will be displayed as black and `blue` as blue
--
-- >>> putStr "Hello \\#"
-- Hello #
--
-- You must use \\ to be able to contain # because otherwise it'be a syntax error
putStr :: String -> IO ()
putStr text = case parse colored "" text of
    Right coloredTexts -> mapM_ printColored coloredTexts
    Left  err          -> Prelude.putStr $ errorBundlePretty err
  where
    printColored = \case Plain   text       -> setSGR [Reset] >> Prelude.putStr text
                         Colored text color -> put text color

-- | The same as 'putStr', but adds a newline character
putStrLn :: String -> IO ()
putStrLn = putStr . (++ "\n")

-- | The same as 'putStrLn', but string is gotten by a Show instance
print :: Show a => a -> IO ()
print = putStrLn . show
