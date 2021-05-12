--
-- EPITECH PROJECT, 2020
-- B-FUN-500-PAR-5-1-funEvalExpr-gabriel.danjon
-- File description:
-- ErrorGestion
--

module ErrorGestion (
    gestErrorFromArgs,
    gestErrorFromString,
) where

import Data.List

import Parser

allowedSpecialChar :: [Char]
allowedSpecialChar = ['+', '-', '/', '*', '^', '.']

successiveOperator :: [Char]
successiveOperator = ['+', '-', '/', '*', '^']

parenthesis :: [Char]
parenthesis = ['(', ')']

numberList :: [Char]
numberList = ['0'..'9']


removeExceciveSpaces :: String -> String
removeExceciveSpaces = foldr spaceRemover ""
    where spaceRemover myChar restString = myChar:if myChar == ' ' then dropWhile (' ' ==) restString else restString

checkEveryCharacters :: String -> Bool
checkEveryCharacters [] = True
checkEveryCharacters (myChar:restString) = case find (==myChar) allowedSpecialChar of
    Just _ -> checkEveryCharacters restString
    Nothing -> case find (==myChar) numberList of
        Just _ -> checkEveryCharacters restString
        Nothing -> case find (==myChar) parenthesis of
            Just _ -> checkEveryCharacters restString
            Nothing -> False

checkConsecutiveNumber :: String -> Bool
checkConsecutiveNumber string
    | length string < 3 = True
checkConsecutiveNumber (fChar:sChar:tChar:restString)
    | fChar >= '0' && fChar <= '9' && sChar == ' ' && tChar >= '0' && tChar <= '9' = False
    | True = checkConsecutiveNumber (sChar:tChar:restString)

checkConsecutiveOperator :: String -> Bool
checkConsecutiveOperator string
    | length string < 2 = True
checkConsecutiveOperator (fChar:sChar:restString) = case find (==fChar) successiveOperator of
    Just _ -> case find (==sChar) successiveOperator of
        Just _ -> False
        Nothing -> checkConsecutiveOperator (sChar:restString)
    Nothing -> checkConsecutiveOperator (sChar:restString)


-- Needed separation between gestErrorFromArgs and gestErrorFromString
-- because first is searching for number without operators ex: "15 15+16"
-- and second is searching every others error through space cleaned string

gestErrorFromArgs :: [String] -> Bool
gestErrorFromArgs [] = False
gestErrorFromArgs (arg:args)
    | length (arg:args) /= 1 = False
    | arg == [] = False
    | checkConsecutiveNumber (removeExceciveSpaces arg) == False = False
    | True = True

gestErrorFromString :: String -> Bool
gestErrorFromString arg
    | checkConsecutiveOperator arg == False = False
    | checkEveryCharacters arg == False = False
    | True = True