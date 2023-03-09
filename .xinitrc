feh --bg-scale ~/bg.jpg
setxkbmap -model pc104 -layout us,ru,ua -variant dvorak,, -option 'grp:alt_shift_toggle'
xsetroot -cursor_name left_ptr

##status-notifier-watcher &
#taffybar &

exec xmonad
