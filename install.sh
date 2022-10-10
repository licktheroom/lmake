#!/bin/bash

luac -o lmake.luac lmake.lua
touch lmake
{ echo \#\!/bin/lua; cat lmake.luac; } > lmake
chmod 775 lmake
rm lmake.luac
