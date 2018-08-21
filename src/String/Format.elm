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
namedValue name val =
    let
        placeholder =
            regex <| "{{\\s*" ++ name ++ "\\s*}}"
    in
        Regex.replace placeholder (\_ -> val)


{-| Interpolate the next unnamed placeholder

    "{{ }} comes before {{ }}"
        |> String.Format.value "dinner"
        |> String.Format.value "dessert"

    -- "dinner comes before dessert"

-}
value : String -> String -> String
value val =
    let
        emptyBraces =
            regex "{{\\s*}}"
    in
        Regex.replaceAtMost 1 emptyBraces (\_ -> val)


regex : String -> Regex.Regex
regex =
    Regex.fromString
        >> Maybe.withDefault Regex.never
