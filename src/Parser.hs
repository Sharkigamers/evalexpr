--
-- EPITECH PROJECT, 2020
-- B-FUN-500-PAR-5-1-funEvalExpr-gabriel.danjon
-- File description:
-- Parser
--

module Parser (
    Parser(..), -- don't forget the (..) to import everything inside it
    parseChar,
    parseAnyChar,
    parseOr,
    parseAnd,
    parseAndWith,
    parseMany,
    parseSome,
    parseDouble,
    parseTuple,
    Functor,
    Applicative,
    Alternative,
    Monad,
) where

import Control.Applicative

-- Bootstrap of the funcEvalExpr with [
--     "Lambdas",
--     "Functors",
--     "Applicative Functors",
--     "Monads"
-- ]
-- Monad is basicly a Bonus

data Parser a = Parser {
    runParser :: String -> Maybe (a, String)
}

-- fmap :: (a -> b) -> f a -> f b [DONE]
-- (<$) :: a -> f b -> f a [NOT DONE]
-- <$> is a shortcut of the fmap function

instance Functor Parser where
    fmap fct parser = Parser $ \string -> case runParser parser string of
        Just (result, restString) -> Just (fct result, restString)
        Nothing -> Nothing


-- pure :: a -> f a [DONE]
-- (<*>) :: f (a -> b) -> f a -> f b [DONE]
-- liftA2 :: (a -> b -> c) -> f a -> f b -> f c [NOT DONE]
-- (*>) :: f a -> f b -> f b [DONE]
-- (<*) :: f a -> f b -> f a [DONE]

instance Applicative Parser where
    pure fArg = Parser $ \string -> Just (fArg, string)
    fParser <*> sParser = Parser $ \string -> case runParser fParser string of
        Just (fResult, fRestString) -> case runParser sParser fRestString of
            Just (sResult, sRestString) -> Just (fResult sResult, sRestString)
            Nothing -> Nothing
        Nothing -> Nothing
    fParser *> sParser = (\fArg -> (\sArg -> sArg)) <$> fParser <*> sParser
    fParser <* sParser = (\fArg -> (\sArg -> fArg)) <$> fParser <*> sParser


-- empty :: f a [DONE]
-- (<|>) :: f a -> f a -> f a [DONE]
-- some :: f a -> f [a] [DONE BUT NOT IN THE INSTANCE]
-- many :: f a -> f [a] [DONE BUT NOT IN THE INSTANCE]

instance Alternative Parser where
    empty = Parser $ (\a -> (\_ -> a)) Nothing
    fParser <|> sParser = Parser $ \string -> case runParser (fParser) string of
        Just _ -> runParser (fParser) string
        Nothing -> runParser (sParser) string


-- (>>=) :: m a -> (a -> m b) -> m b [DONE]
-- (>>) :: m a -> m b -> m b [NOT DONE]
-- return :: a -> m a [NOT DONE]

instance Monad Parser where
    parser >>= fct = Parser $ \string -> case runParser parser string of
        Just (result, restString) -> runParser (fct result) restString
        Nothing -> Nothing

parseChar :: Char -> Parser Char
parseChar myChar = Parser $ \myString -> case myString of
    [] -> Nothing
    (fChar:myString) -> if (fChar == myChar)
        then Just (myChar, myString)
        else Nothing

parseAnyChar :: String -> Parser Char
parseAnyChar [] = Parser $ \_ -> Nothing
parseAnyChar (fChar:fStrings) = Parser $ \sString -> case sString of
    [] -> Nothing
    sString -> case runParser (parseChar fChar) sString of
        Just (myChar, restString) -> Just (myChar, restString)
        Nothing -> runParser (parseAnyChar fStrings) sString

parseOr :: Parser a -> Parser a -> Parser a
parseOr fFunc sFunc = Parser $ \string -> runParser (fFunc <|> sFunc) string

parseAnd :: Parser a -> Parser b -> Parser(a, b)
parseAnd fFunc sFunc = Parser $ \string -> case runParser (fFunc) string of
    Just (fFunc, string) -> case runParser (sFunc) string of
        Just (sFunc, string) -> Just ((fFunc, sFunc), string)
        Nothing -> Nothing
    Nothing -> Nothing


-- parseAndWith can be done using previous functions

parseAndWith :: (a -> b -> c) -> Parser a -> Parser b -> Parser c
parseAndWith additionalArgument fFunc sFunc = Parser $ \string -> case runParser (fFunc) string of
    Just (fFunc, string) -> case runParser (sFunc) string of
        Just (sFunc, string) -> Just (additionalArgument fFunc sFunc, string)
        Nothing -> Nothing
    Nothing -> Nothing


-- parseMany can be done using previous functions

parseMany :: Parser a -> Parser [a]
parseMany func = Parser $ \string -> case runParser (func) string of
    Just (fResult, fRestString) -> case runParser (parseMany func) fRestString of
        Just (sResult, sRestString) -> Just(fResult:sResult, sRestString)
        Nothing -> Just ([fResult], fRestString)
    Nothing -> Just ([], string)


-- parseSome can be done using previous functions

parseSome :: Parser a -> Parser [a]
parseSome func = Parser $ \string -> case runParser (func) string of
    Just (fResult, fRestString) -> case runParser (parseMany func) fRestString of
        Just (sResult, sRestString) -> Just(fResult:sResult, sRestString)
        Nothing -> Just ([fResult], fRestString)
    Nothing -> Nothing


-- ParseUDouble can parse "5." wich means "5.0" and can parse ".5" wich means "0.5"

parseUDouble :: Parser Double
parseUDouble = Parser $ \string -> case runParser ((parseChar '.') *> parseSome (parseAnyChar ['0'..'9'])) string of
    Just (floatResult, restString) -> Just (read ("0." ++ floatResult), restString)
    Nothing -> case runParser (parseSome (parseAnyChar ['0'..'9'])) string of
        Just (fResult, fRestString) -> case runParser (parseChar '.') fRestString of
            Just (sResult, sRestString) -> case runParser (parseSome (parseAnyChar ['0'..'9'])) sRestString of
                Just (tResult, tRestString) -> Just (read (fResult ++ [sResult] ++ tResult) :: Double, tRestString)
                Nothing -> Just (read fResult :: Double, sRestString)
            Nothing -> Just (read fResult :: Double, fRestString)
        Nothing -> Nothing


-- ParseDouble accepts '+' and '-'. You can put a lot of "----" it will change into '-' or '+' depending of the number.

parseDouble :: Parser Double
parseDouble = Parser $ \string -> case runParser (parseSome (parseAnyChar ['+', '-'])) string of
    Just (result, fRestString) -> case (length $ filter (=='-') result) `mod` 2 of
        0 -> case runParser parseUDouble fRestString of
            Just (result, sRestString) -> Just (result, sRestString)
            Nothing -> Nothing
        1 -> case runParser parseUDouble fRestString of
            Just (result, sRestString) -> Just (-result, sRestString)
            Nothing -> Nothing
    Nothing -> case runParser parseUDouble string of
        Just (result, restString) -> Just (result, restString)
        Nothing -> Nothing

parseTuple :: Parser a -> Parser (a,a)
parseTuple func = Parser $ \string -> case string of
    [] -> Nothing
    _ -> runParser ((\x y -> (x,y)) <$> ((parseChar '(') *> func) <*> ((parseChar ',') *> func <* (parseChar ')'))) string
