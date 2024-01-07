module RelativeFileTH where

import Language.Haskell.TH.Syntax
import System.FilePath
import System.Directory

-- https://stackoverflow.com/a/16163949/13413858
addDependentFileRelative :: FilePath -> Q [Dec]
addDependentFileRelative relativeFile = do
    currentFilename <- loc_filename <$> location
    pwd             <- runIO getCurrentDirectory

    let invocationRelativePath = takeDirectory (pwd </> currentFilename) </> relativeFile

    addDependentFile invocationRelativePath

    return []

