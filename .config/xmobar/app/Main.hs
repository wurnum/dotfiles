import Xmobar

config :: Config
config = defaultConfig
  { font = "xft:Hack Nerd Font:pixelsize=14:antialias=true:hinting=true"
  , additionalFonts = ["xft:Font Awesome 6 Free Solid:style-Solid:pixelsize = 12"]
  , bgColor = "#000000"
  , fgColor = "#bababa"
  , textOffset = 16
  , position = TopH 24
  , lowerOnStart = True
  , hideOnStart = False
  , overrideRedirect = True
  , persistent = True
  , commands =
    [ Run XMonadLog
    , Run $ MultiCpu
      [ "-L", "0"
      , "--minwidth", "2"
      , "-h", "red"
      , "-t", "CPU:<fc=#fff><total></fc>%"
      ] 50
    , Run $ MultiCoreTemp
      [ "-t", "Temp: <fc=#fff><max></fc>°C"
      , "-h", "red"
      ] 50
    , Run $ Memory
      [ "-t", "Mem: <fc=#fff><used></fc>G"
      , "-h", "red"
      , "-d", "1"
      , "--"
      , "--scale", "1024"
      ] 20
    , Run $ Weather "UKKK" ["-t", "Temp: <tempC>°C"] 3600
    , Run $ Kbd
      [ ("us(dvorak)", "EN")
      , ("ru", "RU")
      , ("ua", "UA")
      ]
    , Run $ XPropertyLog "_XMONAD_TRAYPAD"
    , Run $ Date "%_d %b %a %H:%M" "date" 10
    ]
  , template = " %XMonadLog% }%date%{ %multicpu% | %multicoretemp% | %memory% | %kbd% |%_XMONAD_TRAYPAD%"
  , alignSep = "}{"
  }

main :: IO ()
main = xmobar config
