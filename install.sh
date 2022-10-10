#!/bin/bash

luac -o lmake.luac lmake.lua
touch lmake
{ echo \#\!/bin/lua; cat lmake.luac; } > lmake
chmod 775 lmake
rm lmake.luac

mv lmake /bin
cp lmake-lib.lua /usr/share/luajit-2.1.0-beta3/jit/
