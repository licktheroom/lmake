--[[

Copyright 2022 licktheroom

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

_______________________________________________________________________________________________-

lmake is a command-line tool made in Lua used to compile code bases.
This library will face a rewrite as I add in interactions with files.

lmake.AddIncludeDirectorys(...)
| Adds directories to lmake_library.library_dirs

lmake.AddLibraryDirectorys(...)
| Adds directories to lmake_library.include_dirs

lmake.BuildDir(path)
| Sets lmake_library.build_dir to path

lmake:CheckCommands()
| Checks the commands in lmake_library.required_commands exist

lmake:CheckPaths()
| Checks the paths in lmake_library.include_dirs, lmake_library.library_dirs, and lmake_library.build_dir
| Then sees if each file in lmake_library.code_includes, lmake_library.code_librarys, and lmake_library.compile_files exist

lmake:Compile()
| Compiles each file in lmake_library.compile_files

lmake.Compiler(complier)
| Sets lmake_library.code_compiler to compiler

lmake.CompileFlags(...)
| Adds flags to lmake_library.compile_flags

lmake.CoreFiles(...)
| Adds files to lmake_library.compile_files

lmake:HasBasicInfo(set_defaults)
| Check if we have the minimum information to compile something

lmake.IncludeFiles(...)
| Adds files to lmake_library.code_includes

lmake.Language(lang)
| Sets lmake_library.code_langauge to lang

lmake.LibraryFiles(...)
| Adds files to lmake_library.code_librarys

lmake.ProjectName(name)
| Sets lmake_library.project_name to name
| If no name if given use the name of the current directory

lmake.SetFlags(...)
| Add flags to lmake_library.lmake_flags
--]]

-- Some nice colors so our output looks fancy
local colors = {}
colors.green = "\27[32m"
colors.reset = "\27[0m"
colors.red   = "\27[31m"

-- start of the actual library

local lmake_library = {}

-- set default variables

lmake_library.build_dir          = nil
lmake_library.code_compiler      = nil
lmake_library.code_includes      = {}
lmake_library.code_langauge      = nil
lmake_library.code_librarys      = {}
lmake_library.compile_files      = {}
lmake_library.compile_flags      = {}
lmake_library.include_dirs       = {"/usr/include/"}
lmake_library.library_dirs       = {"/lib/", "/usr/lib/"}
lmake_library.lmake_flags        = {}
lmake_library.lmake_valid_flags  = {"build-objects", "dont-find", "disable-compiler-check", "c-shared"}
lmake_library.ls_command         = nil
lmake_library.main_threadID      = os.clock()
lmake_library.project_name       = nil
lmake_library.required_commands  = {"ls", "dir", "find"}
lmake_library.version            = "v0.1"

-- functions

function lmake_library.AddIncludeDirectorys(...)
    -- Add each given path to lib.include_dirs
    for i,v in ipairs(type(...) == "table" and ... or {...}) do

        if type(v) == "table" then

            lmake_library.AddIncludeDirectorys(v)

        else

            table.insert(lmake_library.include_dirs, v)

        end

    end
end

function lmake_library.AddLibraryDirectorys(...)
    -- Add each given path to lib.library_dirs

    for i,v in ipairs(type(...) == "table" and ... or {...}) do

        if type(v) == "table" then

            lmake_library.AddLibraryDirectorys(v)

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

        if string.match(io.popen(lmake_library.ls_command.." "..v, lmake_library.main_threadID), "not") then

            table.remove(lmake_library.include_dirs, v)

        end

    end

    for i,v in ipairs(lmake_library.library_dirs) do

        if string.match(io.popen(lmake_library.ls_command.." "..v, lmake_library.main_threadID), "not") then

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

            for i,v in ipairs(lmake_library.code_librarys) do

                local found = false

                for a,b in ipairs(lmake_library.library_dirs) do

                    if io.popen("find "..b.." -iname \"lib"..v..".so\"", lmake_library.main_threadID) ~= "" then

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

-- I need to find a better way to generate commands

function lmake_library:Compile()

    -- ensure we have everything
    lmake_library:CheckCommands()
    lmake_library:CheckPaths()

    -- compile without objects

    if not table.find(lmake_library.lmake_flags, "build-objects") then

        local compile_command = lmake_library.code_compiler

        for i,v in ipairs(lmake_library.compile_flags) do

            compile_command = compile_command.." "..v

        end

        for i,v in ipairs(lmake_library.include_dirs) do

            compile_command = compile_command.." -I"..v

        end

        for i,v in ipairs(lmake_library.library_dirs) do

            compile_command = compile_command.." -L"..v

        end

        compile_command = compile_command.." -o "..lmake_library.project_name

        for i,v in ipairs(lmake_library.compile_files) do
            compile_command = compile_command.." "..v
        end

        print(compile_command)

        local out = io.popen(compile_command, lmake_library.main_threadID)

        if out == "" then
            print("GOOD")
        else
            error("BAD "..out)
        end

    else -- compile with objects

        local compile_command = lmake_library.code_compiler

        for i,v in ipairs(lmake_library.compile_flags) do

            compile_command = compile_command.." "..v

        end

        for i,v in ipairs(lmake_library.include_dirs) do

            compile_command = compile_command.." -I"..v

        end

        for i,v in ipairs(lmake_library.library_dirs) do

            compile_command = compile_command.." -L"..v

        end

        for i,v in ipairs(lmake_library.compile_files) do

            local out

            if table.find(lmake_library.lmake_flags, "c-shared") then
                out = io.popen(compile_command.." -c -fPIC -o "..string.sub(v, 0, string.len(v)-2)..".o "..v, lmake_library.main_threadID)
            else
                out = io.popen(compile_command.." -c -o "..string.sub(v, 0, string.len(v)-2)..".o "..v, lmake_library.main_threadID)
            end

            if out == "" then
                print("GOOD")
            else
                error("BAD "..out)
            end

        end

        if table.find(lmake_library.lmake_flags, "c-shared") then
            compile_command = compile_command.." -shared -o"..lmake_library.project_name..".so"
        else
            compile_command = compile_command.." -o "..lmake_library.project_name
        end

        for i,v in ipairs(lmake_library.compile_files) do

            local s = string.sub(v, 0, string.len(v)-2)
            compile_command = compile_command.." "..s..".o"

        end

        local out = io.popen(compile_command, lmake_library.main_threadID)

        if out == "" then
            print("GOOD")
        else
            print("BAD "..out)
        end

    end

end

function lmake_library.Compiler(compiler)
    if compiler == "Unknown" then

        if lmake_library.code_langauge == "c" then

            lmake_library.code_compiler = "gcc"

        elseif lmake_library.code_langauge == "c++" then

            lmake_library.code_compiler = "g++"

        end

    else

        lmake_library.code_compiler = compiler

    end
end

function lmake_library.CompileFlags(...)

    for i,v in ipairs(type(...) == "table" and ... or {...}) do

        if type(v) == "table" then
            lmake_library.CompileFlags(v)
        else
            table.insert(lmake_library.compile_flags, v)
        end

    end

end

function lmake_library.CoreFiles(...)

    for i,v in ipairs(type(...) == "table" and ... or {...}) do

        if type(v) == "table" then
            lmake_library.CoreFiles(v)
        else
            table.insert(lmake_library.compile_files, v)
        end

    end

end

function lmake_library:HasBasicInfo(set_defaults)

    if #lmake_library.compile_files == 0 then
        return false, "No files to compile"
    elseif lmake_library.code_langauge == nil and lmake_library.code_compiler == nil then
        return false, "No code lang or compiler"
    end

    if set_defaults then
        if lmake_library.build_dir == nil then
            lmake_library.BuildDir(".")
        end

        if lmake_library.code_compiler == nil then

            if lmake_library.code_langauge == "c" then
                lmake_library.Compiler("gcc")
            elseif lmake_library.code_langauge == "c++" then
                lmake_library.Compiler("g++")
            else
                return false, "No compiler provided"
            end

        end

        if lmake_library.project_name == nil then
            lmake_library.ProjectName()
        end
    else
        if lmake_library.build_dir == nil then
            return false, "No build dir"
        end

        if lmake_library.code_compiler == nil then
            return false, "No code compiler"
        end

        if lmake_library.project_name == nil then
            return false, "No project name"
        end
    end

    return true

end

function lmake_library.IncludeFiles(...)
    -- add the files to lib.code_includes
    for i,v in ipairs(type(...) == "table" and ... or {...}) do

        if type(v) == "table" then
            lmake_library.IncludeFiles(v)
        else
            table.insert(lmake_library.code_includes, v)
        end

    end
end

function lmake_library.Language(lang)
    lmake_library.code_langauge = lang
end

function lmake_library.LibraryFiles(...)
    -- add the files to lib.code_librarys
    for i,v in ipairs(type(...) == "table" and ... or {...}) do

        if type(v) == "table" then
            lmake_library.LibraryFiles(v)
        else
            table.insert(lmake_library.code_librarys, v)
        end

    end
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

    for i,v in ipairs(type(...) == "table" and ... or {...}) do

        if type(v) == "table" then
            lmake_library.SetFlags(...)
        else
            table.insert(lmake_library.lmake_flags, v)
        end

    end
end

return lmake_library
