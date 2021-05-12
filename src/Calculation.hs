--
-- EPITECH PROJECT, 2020
-- B-FUN-500-PAR-5-1-funEvalExpr-gabriel.danjon
-- File description:
-- Calculation
--

module Calculation (
    treeCalculation
) where

import Factory

-- Calculation of the tree that check every tree formation
-- (Add || Sub || Mul || Div || Pow)
-- Error gestion of division by 0 that returns Nothing
-- It explains the return value: Maybe (Double)

treeCalculation :: Tree -> Maybe (Double)
treeCalculation tree = case tree of
    Add fNb sNb -> case treeCalculation fNb of
        Just (fResult) -> case treeCalculation sNb of
            Just (sResult) -> Just (fResult + sResult)
            Nothing -> Nothing
        Nothing -> Nothing

    Sub fNb sNb -> case treeCalculation fNb of
        Just (fResult) -> case treeCalculation sNb of
            Just (sResult) -> Just (fResult - sResult)
            Nothing -> Nothing
        Nothing -> Nothing

    Mul fNb sNb -> case treeCalculation fNb of
        Just (fResult) -> case treeCalculation sNb of
            Just (sResult) -> Just (fResult * sResult)
            Nothing -> Nothing
        Nothing -> Nothing

    Div fNb sNb -> case treeCalculation fNb of
        Just (fResult) -> case treeCalculation sNb of
            Just (sResult) -> case sResult of
                0.0 -> Nothing
                _ -> Just (fResult / sResult)
            Nothing -> Nothing
        Nothing -> Nothing

    Pow fNb sNb -> case treeCalculation fNb of
        Just (fResult) -> case treeCalculation sNb of
            Just (sResult) -> Just (fResult ** sResult)
            Nothing -> Nothing
        Nothing -> Nothing

    Number nb -> Just (nb)
