#!/bin/bash
# Copyright 2022 licktheroom

if [ "${1}" = "DEBUG" ] ; then

    luac -o lmake lmake.lua

elif [ ${EUID} -eq 0 ] ; then

    if [ "${1}" = "UNINSTALL" ] ; then

        rm /bin/lmake /usr/share/lua/lmake/new-std.lua /usr/share/lua/lmake/lmake-lib.lua

    elif [ "${1}" = "INSTALL_LIBS" ] ; then

	if [ -d "/usr/share/lua/lmake/" ] ; then
            cp new-std.lua /usr/share/lua/lmake/new-std.lua
            cp lmake-lib.lua /usr/share/lua/lmake/lmake-lib.lua
        else
            mkdir --parents /usr/share/lua/lmake/

            cp new-std.lua /usr/share/lua/lmake/new-std.lua
            cp lmake-lib.lua /usr/share/lua/lmake/lmake-lib.lua
        fi

    elif [ -e "lmake" ] ; then
        cp lmake /bin/lmake

        if [ -d "/usr/share/lua/lmake/" ] ; then
            cp new-std.lua /usr/share/lua/lmake/new-std.lua
            cp lmake-lib.lua /usr/share/lua/lmake/lmake-lib.lua
        else
            mkdir --parents /usr/share/lua/lmake/

            cp new-std.lua /usr/share/lua/lmake/new-std.lua
            cp lmake-lib.lua /usr/share/lua/lmake/lmake-lib.lua
        fi

    else

        luac -o lmake.luac lmake.lua
        touch lmake
        { echo "#!/bin/lua" && cat lmake.luac; } > lmake
        chmod 775 lmake
        rm lmake.luac

        cp lmake /bin/lmake

        if [ -d "/usr/share/lua/lmake/" ] ; then
            cp new-std.lua /usr/share/lua/lmake/new-std.lua
            cp lmake-lib.lua /usr/share/lua/lmake/lmake-lib.lua
        else
            mkdir --parents /usr/share/lua/lmake/

            cp new-std.lua /usr/share/lua/lmake/new-std.lua
            cp lmake-lib.lua /usr/share/lua/lmake/lmake-lib.lua
        fi

    fi


else

    luac -o lmake.luac lmake.lua
    touch lmake
    { echo "#!/bin/lua" && cat lmake.luac; } > lmake
    chmod 775 lmake
    rm lmake.luac

    echo "Please run as root to install."

fi
