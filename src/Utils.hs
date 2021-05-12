--
-- EPITECH PROJECT, 2020
-- B-FUN-500-PAR-5-1-funEvalExpr-gabriel.danjon
-- File description:
-- Utils
--

module Utils (
    help
) where

help :: IO ()
help = putStrLn ("USAGE: ./funEvalExpr arg\n\t[STRING]Arg:\tValue tu calculate (ex: \"3 + 6 + 70\")")