# colored-cli

This utility allows you to output colored text with ease

## Examples

It's better if you hide Prelude functions and expose these like this:

```haskell
import Prelude hiding (putStr, putStrLn, print)
import CLI.Colored
```

Write a string to the standard output device with ansi colors support. You can use next colors: `red`, `black`, `green`, `yellow`, `blue`, `magenta`, `cyan` and `white`

```haskell
>>> putStr "Hello"
Hello

>>> putStr "#red(Hello)"
Hello
```

But this time `Hello` will be red

```haskell
>>> putStr "Hello, #black(this) will be #blue(blue)"
Hello, this will be blue
```

A word `this` will be displayed as black and `blue` as blue

```haskell
>>> putStr "Hello \\#"
Hello #
```

You must use double \\ to be able to contain # because otherwise it'be a syntax error

