#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#
#export XIM="SCIM"
#export XINPUT="SCIM"
#export XMODIFIERS=@im=SCIM  
#export GTK_IM_MODULE=scim  
#export QT_IM_MODULE=scim   
#export XIM_PROGRAM="scim -d"
#scim -d &

#fcitx
#export XIM="fcitx"
#export XINPUT="fcitx"
#export XMODIFIERS="@im=fcitx"  
#export GTK_IM_MODULE=xim
#export QT_IM_MODULE=fcitx   
#export QT4_IM_MODULE=fcitx   
#export XIM_PROGRAM="fcitx -d"
#fcitx -d &

#ibus
export XIM="ibus"
export XIM_PROGRAM="ibus-daemon -d -x"
export XINPUT="ibus"
export XMODIFIERS="@im=ibus"  
export GTK_IM_MODULE=xim
export QT_IM_MODULE=ibus  
export QT4_IM_MODULE=ibus  
ibus-daemon -d -x & 

xcompmgr &

xset m 0 0 &
xsetroot -cursor_name left_ptr &
urxvtd -o -q -f &
unclutter -root -idle 3 &
#nitrogen --restore &
#xbindkeys &
#wbar &

#xscreensaver -no-splash &
#################################
#thunar --daemon &
# exec gnome-session
# exec startkde
# exec startxfce4
#exec fvwm2
# exec icewm
# exec openbox
#exec openbox-session
# exec blackbox
# exec fluxbox
# exec ratpoison
# exec dwm
#exec startlxde
# ... or any other WM of your choosing ...
#exec conky &
#stalonetray &
#xcompmgr -cCfF -r5 -o.65 -l-10 -t-8 -D7 &
#trayer --edge bottom --align right --widthtype pixel --width 140 --height 24 --SetDockType true --transparent true --alpha 255 &

#trayer --edge bottom --align right --expand true --widthtype request --height 24 --SetDockType true --transparent true --alpha 255 &

#nm-applet --sm-disable &
#sleep 10 &
#ivman &
wicd-client &
exec awesome
