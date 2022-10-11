luac -o lmake.luac lmake.lua
touch lmake
{ cat lmake.luac; } > lmake
chmod 775 lmake
rm lmake.luac
