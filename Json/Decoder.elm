module Json.Decoder where

{-| Tools for translating JSON to Elm types.

# Type and Constructors
@docs Decoder, fromString, (:=)

# Built-in decoders
@docs string, float, int, bool, listOf

-}

import List
import Json
import Json.Process (..)
import Json.Output (fromMaybe, output, error, successes)
import Json.Accessor (..)

{-| A Decoder is a Process that takes a Json.Value and produces some 
value `a`.
-}
type Decoder a = Process Json.Value a

type PropertyName = String

{-| A Decoder tagged with a property name, expected to be found in 
a Json.Value.
-}
data NamedDec a = NDec PropertyName (Decoder a)

{-| Constructor of decoders with a name.
-}
(:=) : PropertyName -> Decoder a -> NamedDec a
(:=) k d = NDec k d

infixr 0 :=

{-| Create simple error message.
-}
decoderErrorMsg : String -> String
decoderErrorMsg s = "Could not decode: '" ++ s ++ "'"

-- Built-in decoders --

string : Decoder String
string v = case v of
                Json.String s -> output s
                _ -> error <| decoderErrorMsg "{string}"

float : Decoder Float
float v = case v of
                  Json.Number n -> output n
                  _ -> error <| decoderErrorMsg "{float}"

int : Decoder Int
int = float `mappedTo` floor

bool : Decoder Bool
bool v = case v of
                  Json.Boolean b -> output b
                  _ -> error <| decoderErrorMsg "{bool}"

listOf : Decoder a -> Decoder [a]
listOf f v = case v of
                   Json.Array xs -> output <| successes (List.map f xs)
                   _ -> error <| decoderErrorMsg "{list}"

{-| A Process from String to Json.Value for convenience.

      isRightAnswer : String -> Output Bool
      isRightAnswer s = fromString s >>= int >>= (\n -> output <| n == 42)
-}
fromString : Process String Json.Value
fromString = (\s -> fromMaybe (Json.fromString s))

-- Included generic decoders --

{-- 
   (These will likely be generated by a program in the 
    future, when the Process algebra is more clearly defined. 
    Plus they will probably be implemented in native JS.)
--}

decode1 : NamedDec a1 -> (a1 -> b) -> Decoder b
decode1 (NDec x1 fa1) g json = 
  getVal x1 json 
  >>= fa1 >>= 
  process g

decode2 : NamedDec a1 -> NamedDec a2 -> (a1 -> a2 -> b) -> Decoder b
decode2 (NDec x1 fa1) (NDec x2 fa2) g json =
  getVal x1 json 
  >>= fa1 >>= 
  (\a1 -> getVal x2 json 
          >>= fa2 >>= 
          process (g a1))

decode3 : NamedDec a1 -> NamedDec a2 -> NamedDec a3 -> (a1 -> a2 -> a3 -> b) -> Decoder b
decode3 (NDec x1 fa1) (NDec x2 fa2) (NDec x3 fa3) g json =
  getVal x1 json 
  >>= fa1 >>= 
  (\a1 -> getVal x2 json 
          >>= fa2 >>= 
          (\a2 -> getVal x3 json
                  >>= fa3 >>= 
                  process (g a1 a2)))

decode4 : NamedDec a1 -> NamedDec a2 -> NamedDec a3 -> NamedDec a4 -> (a1 -> a2 -> a3 -> a4 -> b) -> Decoder b
decode4 (NDec x1 fa1) (NDec x2 fa2) (NDec x3 fa3) (NDec x4 fa4) g json = 
  getVal x1 json >>= fa1 >>=  (\a1 -> 
  getVal x2 json >>= fa2 >>=  (\a2 -> 
  getVal x3 json >>= fa3 >>=  (\a3 -> 
  getVal x4 json >>= fa4 >>=  (\a4 -> output <| g a1 a2 a3 a4) ) ) )

decode5 : NamedDec a1 -> NamedDec a2 -> NamedDec a3 -> NamedDec a4 -> NamedDec a5 -> (a1 -> a2 -> a3 -> a4 -> a5 -> b) -> Decoder b
decode5 (NDec x1 fa1) (NDec x2 fa2) (NDec x3 fa3) (NDec x4 fa4) (NDec x5 fa5) g json = 
  getVal x1 json >>= fa1 >>=  (\a1 -> 
  getVal x2 json >>= fa2 >>=  (\a2 -> 
  getVal x3 json >>= fa3 >>=  (\a3 -> 
  getVal x4 json >>= fa4 >>=  (\a4 -> 
  getVal x5 json >>= fa5 >>=  (\a5 -> output <| g a1 a2 a3 a4 a5) ) ) ) )

decode6 : NamedDec a1 -> NamedDec a2 -> NamedDec a3 -> NamedDec a4 -> NamedDec a5 -> NamedDec a6 -> (a1 -> a2 -> a3 -> a4 -> a5 -> a6 -> b) -> Decoder b
decode6 (NDec x1 fa1) (NDec x2 fa2) (NDec x3 fa3) (NDec x4 fa4) (NDec x5 fa5) (NDec x6 fa6) g json = 
  getVal x1 json >>= fa1 >>=  (\a1 -> 
  getVal x2 json >>= fa2 >>=  (\a2 -> 
  getVal x3 json >>= fa3 >>=  (\a3 -> 
  getVal x4 json >>= fa4 >>=  (\a4 -> 
  getVal x5 json >>= fa5 >>=  (\a5 -> 
  getVal x6 json >>= fa6 >>=  (\a6 -> output <| g a1 a2 a3 a4 a5 a6) ) ) ) ) )

decode7 : NamedDec a1 -> NamedDec a2 -> NamedDec a3 -> NamedDec a4 -> NamedDec a5 -> NamedDec a6 -> NamedDec a7 -> (a1 -> a2 -> a3 -> a4 -> a5 -> a6 -> a7 -> b) -> Decoder b
decode7 (NDec x1 fa1) (NDec x2 fa2) (NDec x3 fa3) (NDec x4 fa4) (NDec x5 fa5) (NDec x6 fa6) (NDec x7 fa7) g json = 
  getVal x1 json >>= fa1 >>=  (\a1 -> 
  getVal x2 json >>= fa2 >>=  (\a2 -> 
  getVal x3 json >>= fa3 >>=  (\a3 -> 
  getVal x4 json >>= fa4 >>=  (\a4 -> 
  getVal x5 json >>= fa5 >>=  (\a5 -> 
  getVal x6 json >>= fa6 >>=  (\a6 -> 
  getVal x7 json >>= fa7 >>=  (\a7 -> output <| g a1 a2 a3 a4 a5 a6 a7) ) ) ) ) ) )

decode8 : NamedDec a1 -> NamedDec a2 -> NamedDec a3 -> NamedDec a4 -> NamedDec a5 -> NamedDec a6 -> NamedDec a7 -> NamedDec a8 -> (a1 -> a2 -> a3 -> a4 -> a5 -> a6 -> a7 -> a8 -> b) -> Decoder b
decode8 (NDec x1 fa1) (NDec x2 fa2) (NDec x3 fa3) (NDec x4 fa4) (NDec x5 fa5) (NDec x6 fa6) (NDec x7 fa7) (NDec x8 fa8) g json = 
  getVal x1 json >>= fa1 >>=  (\a1 -> 
  getVal x2 json >>= fa2 >>=  (\a2 -> 
  getVal x3 json >>= fa3 >>=  (\a3 -> 
  getVal x4 json >>= fa4 >>=  (\a4 -> 
  getVal x5 json >>= fa5 >>=  (\a5 -> 
  getVal x6 json >>= fa6 >>=  (\a6 -> 
  getVal x7 json >>= fa7 >>=  (\a7 -> 
  getVal x8 json >>= fa8 >>=  (\a8 -> output <| g a1 a2 a3 a4 a5 a6 a7 a8) ) ) ) ) ) ) )


decode = decode1
