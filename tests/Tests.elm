module Tests exposing (..)

import Test exposing (..)
import Expect
import String.Format


valueTypeChecks : Test
valueTypeChecks =
    test "value works for all types" <|
        \_ ->
            Expect.equal
                ("string: {{ }} int: {{ }} float: {{ }} bool: {{ }} tuple: {{ }} list: {{ }} record: {{ }}"
                    |> String.Format.value "1"
                    |> String.Format.value 1
                    |> String.Format.value 1.3
                    |> String.Format.value True
                    |> String.Format.value ( 1, 2 )
                    |> String.Format.value [ 1, 2 ]
                    |> String.Format.value { x = 1, y = 2 }
                )
                "string: 1 int: 1 float: 1.3 bool: True tuple: (1,2) list: [1,2] record: { x = 1, y = 2 }"


placeholderTypeChecks : Test
placeholderTypeChecks =
    test "placeholder works for all types" <|
        \_ ->
            Expect.equal
                ("string: {{ string }} int: {{ int }} float: {{ float }} bool: {{ bool }} tuple: {{ tuple }} list: {{ list }} record: {{ record }}"
                    |> String.Format.placeholder "string" "1"
                    |> String.Format.placeholder "int" 1
                    |> String.Format.placeholder "float" 1.3
                    |> String.Format.placeholder "bool" True
                    |> String.Format.placeholder "tuple" ( 1, 2 )
                    |> String.Format.placeholder "list" [ 1, 2 ]
                    |> String.Format.placeholder "record" { x = 1, y = 2 }
                )
                "string: 1 int: 1 float: 1.3 bool: True tuple: (1,2) list: [1,2] record: { x = 1, y = 2 }"


placeholderExample : Test
placeholderExample =
    test "String.Format.placeholder example from docs" <|
        \_ ->
            Expect.equal
                ("What happened to the {{ food }}? Maybe {{ person }} ate it?"
                    |> String.Format.placeholder "food" "cake"
                    |> String.Format.placeholder "person" "Joe"
                )
                "What happened to the cake? Maybe Joe ate it?"


valueExample : Test
valueExample =
    test "String.Format.value example from docs" <|
        \_ ->
            Expect.equal
                ("I have concluded that {{ }} is greater than {{ }}"
                    |> String.Format.value 2
                    |> String.Format.value 1
                )
                "I have concluded that 2 is greater than 1"


placeholderMultipleValues : Test
placeholderMultipleValues =
    test "placeholder replaces all placeholders with the same name" <|
        \_ ->
            Expect.equal
                ("First: {{ occ }}, Second: {{ }}, Third: {{occ}}"
                    |> String.Format.placeholder "occ" 2
                )
                "First: 2, Second: {{ }}, Third: 2"


spaceInsensitivity : Test
spaceInsensitivity =
    describe "Spacing tests"
        [ test "value ignores spaces in placeholder" <|
            \_ ->
                Expect.equal
                    ("{{}} {{ }} {{  }}"
                        |> String.Format.value 1
                        |> String.Format.value 2
                        |> String.Format.value 3
                    )
                    "1 2 3"
        , test "placeholder ignores surrounding spaces" <|
            \_ ->
                Expect.equal
                    ("{{occ}} {{ occ}} {{ occ }} {{  occ  }}"
                        |> String.Format.placeholder "occ" 1
                    )
                    "1 1 1 1"
        ]


formatsCorrectNumberOfPlaceholders : Test
formatsCorrectNumberOfPlaceholders =
    test "value only formats the first placeholder, placeholder formats all" <|
        \_ ->
            Expect.equal
                ("{{ }} {{ }} {{ }}"
                    |> String.Format.value 2
                    |> String.Format.placeholder "" 3
                )
                "2 3 3"
