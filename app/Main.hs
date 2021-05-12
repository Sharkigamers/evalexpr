--
-- EPITECH PROJECT, 2020
-- B-FUN-500-PAR-5-1-funEvalExpr-gabriel.danjon
-- File description:
-- Main
--

module Main where

import System.Environment
import System.Exit

import Parser
import Factory
import Calculation
import ErrorGestion

import Utils
import Text.Printf

exitFail :: IO()
exitFail = exitWith (ExitFailure 84)

treeCalculateDisplay :: String -> IO ()
treeCalculateDisplay stringToCalculate = case runParser parseExpr stringToCalculate of
    Just(tree, restString) -> case restString of
        "" -> case treeCalculation tree of
            Just (result) -> printf "%.2f\n" result
            Nothing -> exitFail
        _ -> exitFail
    Nothing -> exitFail

replaceSpecialChar :: String -> String
replaceSpecialChar str = filter (not . (`elem` "\t\r\n ")) str

actions :: [String] -> IO ()
actions args = case length args of
    1 -> case (args!!0) of
        "-h" -> help
        "--help" -> help
        _ -> case gestErrorFromArgs (args) of
            False -> exitFail
            _ -> case replaceSpecialChar (args!!0) of
                spaceCleanedArg -> case gestErrorFromString spaceCleanedArg of
                    False -> exitFail
                    _ -> treeCalculateDisplay spaceCleanedArg
    _ -> exitFail

main :: IO ()
main = getArgs >>= actions
