#!/bin/bash
sleep 0.1
export DISPLAY=:0.0
scrot '%Y-%m-%d.png' -s -e 'mv $f ~/tmp/snanshoot'
