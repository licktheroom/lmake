--[[

Copyright 2022 licktheroom

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]

--[[

This will face a rewrite as I add in interactions with files.

]]

-- Add our library path to where lua looks for required files
package.path = package.path..";/usr/share/lua/lmake/?.lua"

-- Requires and version number
require("new-std")
local lmake_lib = require("lmake-lib")

local version = "v0.1"

-- Start: Handle commandline options

local data = {}
local s = nil

for i = 1, #arg do

    if arg[i] == "-version" then

        print("lmake: "..version.."\nlmake-lib: "..lmake_lib.version.."\nLua: ".._VERSION)
        os.exit()

    end

    if string.sub(arg[i], 1, 2) == "--" then

        s = string.sub(arg[i], 3, -1)

        table.insert(data, {s})

    else

        assert(s, "Stray option "..arg[i])

        table.insert(data[#data], arg[i])

    end

end

for i,v in ipairs(data) do

    if v[1] == "include-dirs" then

        lmake_lib.Set(lmake_lib.Enum.Datatype.IncludeDirs, table.stepped(v, 2))

    elseif v[1] == "lib-dirs" then

        lmake_lib.Set(lmake_lib.Enum.Datatype.LibDirs, table.stepped(v, 2))

    elseif v[1] == "build-dir" then

        lmake_lib.Set(lmake_lib.Enum.Datatype.BuildDir, v[2])

    elseif v[1] == "compiler" then

        lmake_lib.Set(lmake_lib.Enum.Datatype.Compiler, v[2])

    elseif v[1] == "flags" then

        lmake_lib.Set(lmake_lib.Enum.Datatype.Flags, table.stepped(v, 2))

    elseif v[1] == "files" then

        lmake_lib.Set(lmake_lib.Enum.Datatype.Files, table.stepped(v, 2))

    elseif v[1] == "includes" then

        lmake_lib.Set(lmake_lib.Enum.Datatype.Includes, table.stepped(v, 2))

    elseif v[1] == "language" then

        lmake_lib.Set(lmake_lib.Enum.Datatype.Language, v[2])

    elseif v[1] == "librarys" then

        lmake_lib.Set(lmake_lib.Enum.Datatype.Librarys, table.stepped(v, 2))

    elseif v[1] == "name" then

        lmake_lib.Set(lmake_lib.Enum.Datatype.Name, v[2])

    else

        if v[1] == "build-objects" then
            lmake_lib.Set(lmake_lib.Enum.Datatype.lmakeFlag, lmake_lib.Enum.CoreFlags.BuildObjects)
        elseif v[1] == "find" then
            lmake_lib.Set(lmake_lib.Enum.Datatype.lmakeFlag, lmake_lib.Enum.CoreFlags.Find)
        elseif v[1] == "c-shared-library" then
            lmake_lib.Set(lmake_lib.Enum.Datatype.lmakeFlag, lmakie_lib.Enum.CoreFlags.CSharedLibrary)
        else
            error("Unknown option "..v[1])
        end

    end

end

table.print(lmake_lib.Data.Include_dirs)
print("")
table.print(lmake_lib.Data.Library_dirs)
print("\n"..lmake_lib.Data.Build_dir.."\n"..lmake_lib.Data.Compiler)
table.print(lmake_lib.Data.Flags)
print("")
table.print(lmake_lib.Data.Files)
print("")
table.print(lmake_lib.Data.Includes)
print("")
table.print(lmake_lib.Data.Librarys)
print("\n"..lmake_lib.Data.Language.."\n"..lmake_lib.Data.Name)
table.print(lmake_lib.Data.CoreFlags)
print("")

lmake_lib.Compile()

-- End: Handle commandline options
-- Start: Handle lmake files



-- End: Handle lmake files
-- Compile!
