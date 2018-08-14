# String.Format

`String.Format` exposes simple helpers for `String` interpolation to help you
avoid difficult-to-read concatenation.
Both named and unnamed placeholders are supported.

```elm
import String.Format


-- Bad
hello : String -> String
hello name =
    "Hello, " ++ name ++ "!"


-- Readable
hello : String -> String
hello name =
    "Hello, {{ }}!"
        |> String.Format.value name


-- More readable
hello : String -> String
hello name =
    "Hello, {{ name }}!"
        |> String.Format.namedValue "name" name
```
