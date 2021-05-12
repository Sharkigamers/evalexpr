--
-- EPITECH PROJECT, 2020
-- B-FUN-500-PAR-5-1-funEvalExpr-gabriel.danjon
-- File description:
-- Factory
--

module Factory (
    Tree(..), -- don't forget the (..) to import everything inside it
    parseExpr,
) where

import Control.Applicative
import Data.Char

import Parser


-- Creation of data for generating a Tree
-- replacing operators by named operator functions and expressions

data Tree = Number Double
            | Add Tree Tree
            | Sub Tree Tree
            | Mul Tree Tree
            | Div Tree Tree
            | Pow Tree Tree
            deriving Show


-- For being more understanable created named operators

plus :: Char
plus = '+'

minus :: Char
minus = '-'

multiply :: Char
multiply = '*'

divide:: Char
divide = '/'

pow :: Char
pow = '^'

leftParenthesis :: Char
leftParenthesis = '('

rightParenthesis :: Char
rightParenthesis = ')'


-- Function to generate recusively a Tree from right to left

parseExpr :: Parser Tree
parseExpr = Parser $ \string -> case runParser add string of
    Just (result, string) -> Just (result, string)
    Nothing -> Nothing

add :: Parser Tree
add = addition <|> sub
    where addition = do 
            x <- sub
            parseChar plus
            y <- add
            return (Add x y)

-- Here a special sub for parsing only the first number
-- and recusively parse the others '-' and numbers for
-- a better priority. Exemple : "1-2-3"
-- Sub (Sub (Number 1) (Number 2)) (Number 3)
-- Without this : Sub (Number 1) (Sub (Number 2) (Number 3))

sub :: Parser Tree
sub = substraction <|> mult
    where substraction = do
            x <- mult
            maybeSub x

maybeSub :: Tree -> Parser Tree
maybeSub x = substraction <|> return (x)
    where substraction = do
            parseChar minus
            y <- mult
            maybeSub (Sub x y)

mult :: Parser Tree
mult = multiplication <|> divi
    where multiplication = do
            x <- divi
            parseChar multiply
            y <- mult
            return (Mul x y)

divi :: Parser Tree
divi = division <|> po
    where division = do 
            x <- po
            parseChar divide
            y <- divi
            return (Div x y)

po :: Parser Tree
po = power <|> parenth
    where power = do
            x <- parenth
            parseChar pow
            y <- po
            return (Pow x y)
    

parenth :: Parser Tree
parenth = parenthesis <|> Number <$> parseDouble
    where parenthesis = do
            parseChar leftParenthesis
            x <- add
            parseChar rightParenthesis
            return (x)
