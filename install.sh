#!/bin/bash
# Copyright 2022 licktheroom

if [ "${1}" = "debug" ] ; then

	luac5.4 -o lmake lmake.lua

elif [ ${EUID} -eq 0 ] ; then

	if [ "${1}" = "uninstall" ] ; then
		
		rm /bin/lmake /usr/share/lua/5.4/new-std.lua /usr/share/lua/5.4/lmake-lib.lua

	else

		mkdir -p /usr/share/lua/5.4/
	
		cp new-std.lua /usr/share/lua/5.4/new-std.lua
		cp lmake-lib.lua /usr/share/lua/5.4/lmake-lib.lua

		if [ "${1}" != "libs-only" ] ; then
			luac5.4 -o lmake.luac lmake.lua
			touch lmake
			{ echo "#!/bin/lua5.4" && cat lmake.luac; } > lmake
			chmod 775 lmake
			rm lmake.luac

			cp lmake /bin/lmake
		fi
	fi
else

	echo "Please run as admin or do 'install debug'"

fi
