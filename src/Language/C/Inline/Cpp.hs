{-# LANGUAGE PackageImports #-}

module Language.C.Inline.Cpp
  ( module Upstream
  , include
  )
where

import "inline-c-cpp" Language.C.Inline.Cpp as Upstream hiding (include)

import Language.Haskell.TH.Syntax (addDependentFile)
import Language.Haskell.TH        (DecsQ, runIO, location, loc_filename)
import System.FilePath            ((</>), takeDirectory)
import System.Directory           (getCurrentDirectory)
import Control.Monad              (void)

include :: String -> DecsQ
include s
  | null s = fail "inline-c: empty string (include)"
  | head s == '<' = verbatim $ "#include " ++ s
  | otherwise = do
      void $ addDependentFileRelative s
      verbatim $ "#include \"" ++ s ++ "\""

addDependentFileRelative :: FilePath -> DecsQ
addDependentFileRelative relativeFile = do
    currentFilename <- loc_filename <$> location
    pwd             <- runIO getCurrentDirectory

    let invocationRelativePath = takeDirectory (pwd </> currentFilename) </> relativeFile

    addDependentFile invocationRelativePath

    return []
