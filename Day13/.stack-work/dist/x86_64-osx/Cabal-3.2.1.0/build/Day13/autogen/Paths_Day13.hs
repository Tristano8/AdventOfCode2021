{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_Day13 (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/hughdavidson/dev/advent-of-code-2021/Day13/.stack-work/install/x86_64-osx/069580059aa71c27680050af25759bb89c3b64767cc8b3672616bfb5fb9329a0/8.10.7/bin"
libdir     = "/Users/hughdavidson/dev/advent-of-code-2021/Day13/.stack-work/install/x86_64-osx/069580059aa71c27680050af25759bb89c3b64767cc8b3672616bfb5fb9329a0/8.10.7/lib/x86_64-osx-ghc-8.10.7/Day13-0.1.0.0-9Zu6zn0InxpH5j7EqtxWL3-Day13"
dynlibdir  = "/Users/hughdavidson/dev/advent-of-code-2021/Day13/.stack-work/install/x86_64-osx/069580059aa71c27680050af25759bb89c3b64767cc8b3672616bfb5fb9329a0/8.10.7/lib/x86_64-osx-ghc-8.10.7"
datadir    = "/Users/hughdavidson/dev/advent-of-code-2021/Day13/.stack-work/install/x86_64-osx/069580059aa71c27680050af25759bb89c3b64767cc8b3672616bfb5fb9329a0/8.10.7/share/x86_64-osx-ghc-8.10.7/Day13-0.1.0.0"
libexecdir = "/Users/hughdavidson/dev/advent-of-code-2021/Day13/.stack-work/install/x86_64-osx/069580059aa71c27680050af25759bb89c3b64767cc8b3672616bfb5fb9329a0/8.10.7/libexec/x86_64-osx-ghc-8.10.7/Day13-0.1.0.0"
sysconfdir = "/Users/hughdavidson/dev/advent-of-code-2021/Day13/.stack-work/install/x86_64-osx/069580059aa71c27680050af25759bb89c3b64767cc8b3672616bfb5fb9329a0/8.10.7/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Day13_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Day13_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "Day13_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "Day13_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Day13_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Day13_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
