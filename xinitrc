#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#if [ -d /etc/X11/xinit/xinitrc.d ]; then
#  for f in /etc/X11/xinit/xinitrc.d/*; do
#    [ -x "$f" ] && . "$f"
#  done
#  unset f
#fi
#
# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice

export LANG="en_US.UTF-8"

export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XIM=fcitx
fcitx &

#
#sleep 10
#killall conky
#conky -c /home/zjz311/.conkyrc
#exit
#
#xcompmgr &
#DEFAULT_SESSION=startxfce4
#case $1 in
#    awesome)
#        exec awesome
#        ;;
#    *)
#        exec $DEFAULT_SESSION
#        ;;
#esac
#~/.config/autostart/trackpoint.sh

#sudo modprobe ip_conntrack_ftp
#sudo mount --bind ~/mcm/ /srv/ftp

exec startxfce4

#Autostart START
#Autostart END
#xsetroot -cursor_name left_ptr
#exec xmonad
