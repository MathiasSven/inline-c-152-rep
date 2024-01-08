{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}

module Main where

import qualified Language.C.Inline.Cpp as C
import           Large

C.context $ C.cppCtx

C.include "test.hpp"

addOne :: C.CInt -> C.CInt
addOne n = [C.pure| int { add_one($(int n)) } |] :: C.CInt


main :: IO () 
main = print (addOne 1)

