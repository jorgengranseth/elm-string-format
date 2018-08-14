module String.Format
    exposing
        ( namedValue
        , value
        )

{-| Simple, pipable helpers to avoid difficult-to-read String concatenation
by interpolating `String` values.

You can either specify placeholder names or push values into
the next empty placeholder.

    """
    {{ named }} is replaced everywhere {{ named }},
    whereas empty placeholders: {{ }} and {{ }},
    act as unique slots for the value function
    """
        |> String.Format.value "first"
        |> String.Format.namedValue "named" "yay!"
        |> String.Format.value "second"

    -- """
    -- yay! is replaced everywhere yay!,
    -- whereas empty placeholders: first and second,
    -- act as unique slots for the value function
    -- """


# Formatters

@docs namedValue
@docs value

-}

import Regex


{-| Interpolate a named placeholder

    "What happened to the {{ food }}? Maybe {{ person }} ate it?"
        |> String.Format.namedValue "food" "cake"
        |> String.Format.namedValue "person" "Joe"

    -- "What happened to the cake? Maybe Joe ate it?"

-}
namedValue : String -> String -> String -> String
namedValue name value =
    let
        placeholder =
            Regex.regex <| "{{\\s*" ++ name ++ "\\s*}}"
    in
        Regex.replace Regex.All placeholder (\_ -> value)


{-| Interpolate the next unnamed placeholder

    "{{ }} comes before {{ }}"
        |> String.Format.value "2"
        |> String.Format.value "1"

    -- 2 comes before 1

-}
value : String -> String -> String
value val =
    let
        firstOccurrence =
            Regex.AtMost 1

        emptyBraces =
            Regex.regex "{{\\s*}}"
    in
        Regex.replace firstOccurrence emptyBraces (\_ -> val)
