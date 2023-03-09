{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

module Main (main) where

import System.Taffybar
import System.Taffybar
import System.Taffybar.Information.CPU
import System.Taffybar.SimpleConfig
import System.Taffybar.Util
import System.Taffybar.Widget.SimpleClock
import System.Taffybar.Widget
import System.Taffybar.Widget.Workspaces
import System.Taffybar.Widget.FreedesktopNotifications
import System.Taffybar.Widget.SNITray 
import System.Taffybar.Widget.Generic.Graph
import System.Taffybar.Widget.Generic.PollingGraph

import GI.Gtk.Objects.Widget
import qualified GI.Gtk as Gtk

import Control.Exception
import Control.Monad.Reader


import qualified System.Taffybar.Context as BC (BarConfig(..), TaffybarConfig(..))
import           System.Taffybar.Context hiding (TaffybarConfig(..), BarConfig(..))

main :: IO ()
main = dyreTaffybar $ toTaffyConfig config

workspaces :: TaffyIO Widget
workspaces = workspacesNew defaultWorkspacesConfig
  { showWorkspaceFn = hideEmpty
  , getWindowIconPixbuf = myGetWindowIconPixbuf
  }

clock :: ReaderT Context IO Widget
clock = textClockNew Nothing "%H:%M " 1

tray :: ReaderT Context IO Widget
tray = sniTrayNew

config :: SimpleTaffyConfig
config = defaultSimpleTaffyConfig    
  { monitorsAction = useAllMonitors
  , barHeight      = ScreenRatio $ 1 / 27
  , barPadding     = 8
  , barPosition    = Top
  , widgetSpacing  = 4
  , startWidgets   = [workspaces]
  , centerWidgets  = [clock]
  , endWidgets     = [tray]
  , cssPaths       = []
  , startupHook    = return ()
  }

myGetWindowIconPixbuf :: WindowIconPixbufGetter
myGetWindowIconPixbuf =
  scaledWindowIconPixbufGetter $
    handleException getWindowIconPixbufFromDesktopEntry
      <|||> handleException getWindowIconPixbufFromClass
      <|||> handleException getWindowIconPixbufFromEWMH
  where
    handleException :: WindowIconPixbufGetter -> WindowIconPixbufGetter
    handleException getter = \size windowData ->
      ReaderT $ \c ->
        catch (runReaderT (getter size windowData) c) $ \(_ :: SomeException) ->
          return Nothing
