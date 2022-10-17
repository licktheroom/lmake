--[[

Copyright 2022 licktheroom

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

_______________________________________________________________________________________________-

Make was to simple and I couldn't understand cmake. So, I made this to flex lua.

TODO: Multi-threading
TODO: lmake.cache so we don't have to find the includes and librarys each time we compile

PharseCmdOutput(cmd, threadID)
TableFind(table, search)

lmake.AddIncludeDirectorys(...)
lmake.AddLibraryDirectorys(...)
lmake.BuildDirectory(path)
lmake:CheckCommands()
lmake:CheckPaths()
lmake:Compile()
lmake.Compiler(complier)
lmake.CompileFlags(...)
lmake.CoreFiles(...)
lmake:HasBasicInfo()
lmake.IncludeFiles(...)
lmake.Language(lang)
lmake.LibraryFiles(...)
lmake.ProjectName(name)
lmake.SetFlags(...)
--]]

-- Some nice colors so our output looks fancy
local colors = {}
colors.green = "\27[32m"
colors.reset = "\27[0m"
colors.red   = "\27[31m"

-- start of the actual library

local lmake_library = {}

-- set default variables

lmake_library.build_dir         = nil
lmake_library.code_compiler     = nil
lmake_library.code_includes     = {}
lmake_library.code_langauge     = nil
lmake_library.code_librarys     = {}
lmake_library.compile_files     = {}
lmake_library.compile_flags     = {}
lmake_library.include_dirs      = {"/usr/include/"}
lmake_library.library_dirs      = {"/lib/", "/usr/lib/"}
lmake_library.lmake_flags       = {}
lmake_library.lmake_valid_flags = {"build-objects", "dont-find", "disable-compiler-check", "version"}
lmake_library.ls_command        = nil
lmake_library.main_threadID     = os.clock()
lmake_library.project_name      = nil
lmake_library.required_commands = {"ls", "dir", "find"}
lmake_library.version           = "v0.1"

-- functions

function lmake_library.AddIncludeDirectorys(...)
    -- Add each given path to lib.include_dirs
    local tab = {...}

    for i,v in ipairs(tab) do

        if type(v) == "table" then

            for a,d in ipairs(v) do

                table.insert(lmake_library.include_dirs, v)

            end

        else

            table.insert(lmake_library.include_dirs, v)

        end

    end
end

function lmake_library.AddLibraryDirectorys(...)
    -- Add each given path to lib.library_dirs
    local tab = {...}

    for i,v in ipairs(tab) do

        if type(v) == "table" then

            for a,d in ipairs(v) do

                table.insert(lmake_library.library_dirs, v)

            end

        else

            table.insert(lmake_library.library_dirs, v)

        end

    end
end

function lmake_library.BuildDir(path)
    -- set lib.build_dir to path

    if string.sub(path, string.len(path)) == "/" then

        lmake_library.build_dir = path

    else

        lmake_library.build_dir = path.."/"

    end

end

function lmake_library:CheckCommands()

    -- see if we should find

    if table.find(lmake_library.lmake_flags, "dont-find") then

        table.remove(lmake_library.required_commands, "find")

    end

    -- loop through and check each command

    for i,v in ipairs(lmake_library.required_commands) do

        if not table.find(lmake_library.lmake_flags, "disable-compiler-check") and v == lmake_library.code_compiler then

            local out = io.popen(v.." -v", lmake_library.main_threadID)

            if string.match(out, "not") then

                table.remove(lmake_library.required_commands, v)

            end

        else

            local out = io.popen(v, lmake_library.main_threadID)

            if string.match(out, "not") then

                table.remove(lmake_library.required_commands, v)

            end

        end

    end

    if table.find(lmake_library.required_commands, "ls") then

        lmake_library.ls_command = "ls"

    elseif table.find(lmake_library.required_commands, "dir") then

        lmake_library.ls_command = "dir"

    else

        error("Do not have 'ls' or 'dir'.")

    end

    if not table.find(lmake_library.required_commands, "find") and not table.find(lmake_library.lmake_flags, "dont-find") then
        print("'find' command not found, assuming dont-find.")

        table.insert(lmake_library.lmake_flags, "dont-find")

    end

end

function lmake_library:CheckPaths()

    -- Check lib.build_dir

    if string.match(io.popen(lmake_library.ls_command.." "..lmake_library.build_dir, lmake_library.main_threadID), "not") then

        error("'"..lmake_library.build_dir.."' does not exist.")

    end

    -- Check files in lib.compile_files

    for i,v in ipairs(lmake_library.compile_files) do

        if string.match(io.popen(lmake_library.ls_command.." "..v, lmake_library.main_threadID), "not") then

            error("Core file '"..v.."' does not exist")

        end

    end

    -- Check each path in lib.include_dirs and lib.library_dirs

    for i,v in ipairs(lmake_library.include_dirs) do

        if string.match(io.popen(lmake_library.ls_command.." "..v), "not", lmake_library.main_threadID) then

            table.remove(lmake_library.include_dirs, v)

        end

    end

    for i,v in ipairs(lmake_library.library_dirs) do

        if string.match(io.popen(lmake_library.ls_command.." "..v), "not", lmake_library.main_threadID) then

            table.remove(lmake_library.library_dirs, v)

        end

    end

    -- Check for librarys and includes if any

    if not table.find(lmake_library.lmake_flags, "dont-find") then

        if #lmake_library.code_includes ~= 0 then

            for i,v in ipairs(lmake_library.code_includes) do

                local found = false

                for a,b in ipairs(lmake_library.include_dirs) do

                    if io.popen("find "..b.." -iname \""..v..".h\"", lmake_library.main_threadID) ~= "" then

                        found = true

                    end

                end

                if not found then

                    error("Include file '"..v.."' does not exist.")

                end

            end

        end

        if #lmake_library.code_librarys ~= 0 then

            for i,v in ipairs(lmake_librarys.code_librarys) do

                local found = false

                for a,b in ipairs(lmake_library.library_dirs) do

                    if io.popen("find "..b.." -iname \""..v..".so\"", lmake_library.main_threadID) ~= "" then

                        found = true

                    end

                end

                if not found then

                    error("Library file '"..v.."' does not exist.")

                end

            end

        end

    end

end

function lmake_library:Compile()

end

function lmake_library.Compiler(compiler)

end

function lmake_library.CompileFlags(overwrite, ...)
    -- check if we should overwrite the flags
    if overwrite then
        lmake_library.compile_flags = {}
    end

    local ar = {...}

    -- loop through given flags and put them in lib.compile_flags
    for i,v in ipairs(ar) do
        table.insert(lmake_library.compile_flags, v)
    end
end

function lmake_library.CoreFiles(...)
    local f = {...}

    -- add the files to lib.compile_files
    for i,v in ipairs(f) do
        table.insert(lmake_library.compile_files, v)
    end
end

function lmake_library.IncludeFiles(...)
    -- add the files to lib.code_includes
end

function lmake_library.Language(lang)

end

function lmake_library.LibraryFiles(...)
    -- add the files to lib.code_librarys
end

function lmake_library.ProjectName(name)
    -- set name if we were given one
    if name then
        lmake_library.project_name = name
    else
        --if not given a name, get current directory and set name to that

        local pwd = os.getenv("PWD")

        if pwd then
            local t = {}

            for v in string.gmatch(pwd, "/(%w+)") do
                t[#t + 1] = v
            end


            lmake_library.project_name = t[#t]
        else
            -- fall back to build
            lmake_library.project_name = "build"
        end
    end
end

function lmake_library.SetFlags(...)
    -- add the flags to lib.lmake_flags
end

return lmake_library
