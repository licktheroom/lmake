--[[

Copyright 2022 licktheroom

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]

package.path = package.path..";/usr/share/lua/lmake/?.lua"

require("new-std")
local lmake_lib = require("lmake-lib")

local version = "v0.1"

-- pharse command input

local data = {}
local s = nil

for i = 1, #arg do

    if arg[i] == "--version" or arg[i] == "-v" then

        print("lmake "..version.."\nlmake-lib "..lmake_lib.version.."\nLua ".._VERSION)
        os.exit()

    end

    if string.sub(arg[i], 1, 2) == "--" then

        s = string.sub(arg[i], 3, -1)

        table.insert(data, {s})

    else

        if s == nil then

            error("Stray option")

        end

        table.insert(data[#data], arg[i])

    end

end

table.print(data)

-- continue

for i,v in ipairs(data) do

    if v[1] == "include-dirs" then

        lmake_lib.AddIncludeDirectorys(table.stepped(v, 2))

    elseif v[1] == "lib-dirs" then

        lmake_lib.AddLibraryDirectorys(table.stepped(v, 2))

    elseif v[1] == "build-dir" then

        lmake_lib.BuildDir(v[2])

    elseif v[1] == "compiler" then

        lmake_lib.Compiler(v[2])

    elseif v[1] == "flags" then

        lmake_lib.CompileFlags(table.stepped(v, 2))

    elseif v[1] == "files" then

        lmake_lib.CoreFiles(table.stepped(v, 2))

    elseif v[1] == "includes" then

        lmake_lib.IncludeFiles(table.stepped(v, 2))

    elseif v[1] == "language" then

        lmake_lib.Language(v[2])

    elseif v[1] == "librarys" then

        lmake_lib.LibraryFiles(table.stepped(v, 2))

    elseif v[1] == "name" then

        lmake_lib.ProjectName(v[2])

    elseif table.find(lmake_lib.lmake_valid_flags, v[1]) then

        lmake_lib.SetFlags(v[1])

    else

        error("Invalid option: "..v[1])

    end

end

lmake_lib:Compile()
