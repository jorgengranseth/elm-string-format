module Tests exposing (..)

import Test exposing (..)
import Expect
import String.Format


namedValueExample : Test
namedValueExample =
    test "namedValue example from docs" <|
        \_ ->
            Expect.equal
                ("What happened to the {{ food }}? Maybe {{ person }} ate it?"
                    |> String.Format.namedValue "food" "cake"
                    |> String.Format.namedValue "person" "Joe"
                )
                "What happened to the cake? Maybe Joe ate it?"


valueExample : Test
valueExample =
    test "value example from docs" <|
        \_ ->
            Expect.equal
                ("{{ }} comes before {{ }}"
                    |> String.Format.value "dinner"
                    |> String.Format.value "dessert"
                )
                "dinner comes before dessert"


nameMultipleValues : Test
nameMultipleValues =
    test "namedValue replaces all placeholders with the same name" <|
        \_ ->
            Expect.equal
                ("First: {{ occ }}, Second: {{ }}, Third: {{ occ }}"
                    |> String.Format.namedValue "occ" "2"
                )
                "First: 2, Second: {{ }}, Third: 2"


spaceInsensitivity : Test
spaceInsensitivity =
    describe "space insensitivity"
        [ test "value ignores spaces in placeholder" <|
            \_ ->
                Expect.equal
                    ("{{}} {{ }} {{  }}"
                        |> String.Format.value "1"
                        |> String.Format.value "2"
                        |> String.Format.value "3"
                    )
                    "1 2 3"
        , test "namedValue ignores surrounding spaces" <|
            \_ ->
                Expect.equal
                    ("{{occ}} {{ occ}} {{ occ }} {{  occ  }}"
                        |> String.Format.namedValue "occ" "1"
                    )
                    "1 1 1 1"
        ]


formatsCorrectNumberOfPlaceholders : Test
formatsCorrectNumberOfPlaceholders =
    test "value only formats the first placeholder, namedValue formats all" <|
        \_ ->
            Expect.equal
                ("{{ }} {{ }} {{ }} {{ }}"
                    |> String.Format.value "2"
                    |> String.Format.namedValue "" "3"
                )
                "2 3 3 3"
