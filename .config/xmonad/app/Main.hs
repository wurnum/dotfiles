module Main (main) where

import XMonad 

import XMonad.Actions.MouseResize

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
--import XMonad.Hooks.TaffybarPagerHints

import XMonad.Layout
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.NoBorders

import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Hacks
import XMonad.Util.SpawnOnce (spawnOnce)

main :: IO ()
main = do
  xmonad
    . withSB mySB
    . docks
--    . pagerHints
    . ewmh
    . ewmhFullscreen $ myConfig

mySB = statusBarProp "xmobar" (pure myPP)

myPP = def
  { ppCurrent = xmobarColor "yellow" ""
  , ppOrder = \(ws:_) -> [ws]
  }

myConfig = def
  { modMask = mod4Mask
  , terminal = myTerminal
  , workspaces = myWorkspaces
  , borderWidth = myBorderWidth
  , normalBorderColor = "#333333"
  , focusedBorderColor = "#f00"
  , layoutHook = myLayoutHook
  , logHook = myLogHook
  , startupHook = myStartupHook
  , handleEventHook = myEventHook
  , manageHook = myManageHook
  , focusFollowsMouse = True
  , clickJustFocuses = True
  }
  `additionalKeysP` myKeys

myEventHook = trayerAboveXmobarEventHook <> trayerPaddingXmobarEventHook

myWorkspaces :: [String]
myWorkspaces = map show [1 .. 9 :: Int]

myManageHook :: ManageHook
myManageHook = composeAll
  [ className =? "vlc"	--> doFloat
  , className =? "Gimp" --> doFloat
  , className =? "songrec" --> doFloat
  ]

myBorderWidth :: Dimension
myBorderWidth = 2

myLogHook :: X ()
myLogHook = return ()

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "xcape -t 300 -e 'Control_L=Escape'"
  spawnOnce "volnoti -t 1"
  spawnOnce "nm-applet --indicator &"
  --spawnOnce "gxkb &"
  spawnOnce "picom &"
  spawn "/home/qravne/.config/xmonad/scripts/trayer.sh"
  setWMName "LG3D"

myLayoutHook = smartBorders $ avoidStruts tiled ||| smartBorders (avoidStruts mirrorTiled) ||| noBorders Full
    where
      tiled = mouseResizableTile
        { nmaster = 1
        , masterFrac = 1 / 2
        , slaveFrac = 1 / 2
        , fracIncrement = 2 / 100
        , draggerType = FixedDragger 1 1
        }
      mirrorTiled = mouseResizableTile
        { nmaster = 1
        , masterFrac = 1 / 2
        , slaveFrac = 1 / 2
        , fracIncrement = 2 / 100
        , draggerType = FixedDragger 1 1
        }

myFont :: String
myFont = "xft:Widesevka:regular:size=13:antialias=true:hinting=true"

myTerminal :: String
myTerminal = "alacritty"

myBrowser :: String
myBrowser = "brave"

myKeys :: [(String, X ())]
myKeys =
  [ ("M-S-r", spawn "xmonad --recompile && xmonad --restart")
  , ("M-S-s", spawn "maim -s | xclip -selection clipboard -t image/png -i")
  , ("M-S-b", spawn myBrowser)
  , ("M-S-f", sendMessage ToggleStruts)
  , ("M-S-t", spawn "killall taffybar; cd ~/.config/taffybar && stack install; taffybar &")

  -- Volume control
  , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ && volnoti-show $(amixer get Master | grep -Po \"[0-9]+(?=%)\" | tail -1)")
  , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- && volnoti-show $(amixer get Master | grep -Po \"[0-9]+(?=%)\" | tail -1)")
  , ("<XF86AudioMute>", spawn "amixer set Master toggle; if amixer get Master | grep -Fq \"[off]\"; then volnoti-show -m; else volnoti-show $(amixer get Master | grep -Po \"[0-9]+(?=%)\" | tail -1); fi")
  ]
