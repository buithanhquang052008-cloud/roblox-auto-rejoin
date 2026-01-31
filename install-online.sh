#!/data/data/com.termux/files/usr/bin/bash

pkg update -y
pkg install git nodejs -y

git clone https://github.com/buithanhquang052008-cloud/roblox-auto-rejoin.git
cd roblox-auto-rejoin || exit 1

node rejoin.cjs
