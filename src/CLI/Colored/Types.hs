module CLI.Colored.Types where

import           System.Console.ANSI

data Colored = Colored String Color | Plain String deriving Show
