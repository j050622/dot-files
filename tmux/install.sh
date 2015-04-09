#!/bin/sh

sudo cp safe-reattach-to-user-namespace /bin/
ln -sf `pwd`/tmux.conf $HOME/.tmux.conf
