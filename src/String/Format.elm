module String.Format
    exposing
        ( placeholder
        , value
        )

{-| A simple module to interpolate values into `String`s

@docs placeholder
@docs value

-}

import Regex


{-| Interpolate a named placeholder

    "What happened to the {{ food }}? Maybe {{ person }} ate it?"
        |> String.Format.placeholder "food" "cake"
        |> String.Format.placeholder "person" "Joe"

    -- "What happened to the cake? Maybe Joe ate it?"

    "{{ person }} is {{ age }} years old."
        |> String.Format.placeholder "person" "Michael"
        |> String.Format.placeholder "age" 12

    -- "Michael is 12 years old"

-}
placeholder : String -> a -> String -> String
placeholder name value =
    let
        name_ =
            "{{\\s*" ++ name ++ "\\s*}}"

        value_ =
            stringify value
    in
        Regex.replace Regex.All (Regex.regex name_) (\_ -> value_)


{-| Interpolate the next unnamed placeholder

    "I have concluded that {{ }} is greater than {{ }}"
        |> String.Format.value 2
        |> String.Format.value 1

    -- I have concluded that 2 is greater than 1

-}
value : a -> String -> String
value val =
    let
        firstOccurrence =
            Regex.AtMost 1

        emptyBraces =
            Regex.regex "{{\\s*}}"

        val_ =
            stringify val
    in
        Regex.replace firstOccurrence emptyBraces (\_ -> val_)


stringify : a -> String
stringify value =
    let
        string_value =
            toString value
    in
        if String.startsWith "\"" string_value then
            string_value
                |> String.dropLeft 1
                |> String.dropRight 1
        else
            string_value
