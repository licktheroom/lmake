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
lmake.CompileFlags(overwrite, ...)
lmake.CoreFiles(...)
lmake.IncludeFiles(...)
lmake.LanguageAndCompiler(lang, compiler, disable_compliler_check)
lmake.LibraryFiles(...)
lmake.ProjectName(name)
--]]

local function PharseCmdOutput(cmd, threadID)
    -- execute the given command and send the output to a file with the name of theadID
    local success, txt = os.execute(cmd.." >> "..threadID.." 2>&1")

    -- open and read the entire file
    local f = io.open(threadID)

    local a = f:read("*a")

    f:close()

    -- remove the file so we don't have clutter and return what we read
    os.execute("rm "..threadID)

    return a
end

-- TODO: Search for more than one variable

local function TableFind(table, search)
    -- loop through and see if table has a given value
    for i,v in ipairs(table) do
        if v == search then
            return i
        end
    end

    return nil
end

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
lmake_library.main_threadID     = os.clock()
lmake_library.project_name      = nil
lmake_library.required_commands = {"ls", "dir", "find"}
lmake_library.version           = "v0.0.1"

-- functions

-- TODO: this function
function lmake_library.AddIncludeDirectorys(...)
    -- Add each given path to lib.include_dirs
end

function lmake_library.AddLibraryDirectorys(...)
    -- Add each given path to lib.library_dirs
end

function lmake_library.BuildDir(path)
    -- set lib.build_dir to path
    lmake_library.build_dir = path
end

function lmake_library:CheckCommands()

    -- loop through and check each command

    for i,v in ipairs(lmake_library.required_commands) do

        io.write("Checking for "..v.."...")
        io.flush()

        local output

        -- we want to treat the compiler a little differen by running it with -v
        if v == lmake_library.code_compiler then
            output = PharseCmdOutput(v.." -v", lmake_library.main_threadID)
        else
            output = PharseCmdOutput(v, lmake_library.main_threadID)
        end

        -- output the resualt
        if string.match(output, "not") then
            table.remove(lmake_library.required_commands, TableFind(lmake_library.required_commands, v))
            print(colors.red.." FAIL"..colors.reset)
        else
            print(colors.green.." OK"..colors.reset)
        end

    end

    -- ensure we have at least ls or dir
    if not TableFind(lmake_library.required_commands, "ls") and not TableFind(lmake_library.required_commands, "dir") then
        return false, "ERROR: ls and dir not found, need at least one of them!"
    end

    -- see if we have find, not required but nice to have
    if not TableFind(lmake_library.required_commands, "find") then
        print("Command 'find' wasn't found. Unable to look for librarys and include files.")
        io.write("Continue anyway? (Yes, No): ")

        local input = string.lower(io.read())

        if input == "n" or input == "no" then
            print("Leaving...")

            os.exit()
        end
    end

    return true

end

function lmake_library:CheckPaths()
    -- Check lib.build_dir
    -- Check files in lib.compile_files
    -- Check each path in lib.include_dirs and lib.library_dirs
    -- Check for librarys and includes if any
end

function lmake_library:Compile()
    print("\nEntering compile state, doing final checks.\n")

    -- check build dir

    io.write("Checking for directory '"..lmake_library.build_dir.."'...")
    io.flush()

    local output

    if TableFind(lmake_library.required_commands, "ls") then
        output = PharseCmdOutput("ls "..lmake_library.build_dir, lmake_library.main_threadID)
    else
        output = PharseCmdOutput("dir "..lmake_library.build_dir, lmake_library.main_threadID)
    end

    if string.match(output, "not") then
        print(colors.red.." FAIL"..colors.reset)
        return false, "ERROR: '"..lmake_library.build_dir.."' does not exist."
    end

    print(colors.green.." OK"..colors.reset)

    -- check files

    for i,v in ipairs(lmake_library.compile_files) do
        io.write("Checking for file '"..v.."'...")
        io.flush()

        if TableFind(lmake_library.required_commands, "ls") then
            output = PharseCmdOutput("ls "..v, lmake_library.main_threadID)
        else
            output = PharseCmdOutput("dir "..v, lmake_library.main_threadID)
        end

        if string.match(output, "not") then
            print(colors.red.." FAIL"..colors.reset)
            return false, "ERROR: '"..v.."' does not exist."
        end

        print(colors.green.." OK"..colors.reset)
    end

    -- Show the user we started building
    print("\nBuilding "..lmake_library.project_name.."...\n")

    -- create the basic command

    local compile_command = lmake_library.code_compiler
    for i,v in ipairs(lmake_library.compile_flags) do
        compile_command = compile_command.." "..v
    end

    compile_command = compile_command.." -o "..lmake_library.build_dir.."/"..lmake_library.project_name.." "

    -- Loop through each file and compile it!
    for i,v in ipairs(lmake_library.compile_files) do

        compile_command = compile_command..v

        io.write("Compiling "..v.."...")
        io.flush()

        output = PharseCmdOutput(compile_command, lmake_library.main_threadID)

        if output == "" then
            print(colors.green.." OK"..colors.reset)
        else
            print(colors.red.." FAIL"..colors.reset)
            return false, "ERROR?\n"..output
        end
    end

    return true
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

function lmake_library.LanguageAndCompiler(lang, compiler, disable_compliler_check)

    -- Set lib.code_langauge and set compiler

    lmake_library.code_langauge = lang

    if compiler == nil then
        if lang == "c" then
            lmake_library.code_compiler = "gcc"
        elseif lang == "c++" then
            lmake_library.code_compiler = "g++"
        else
            return false, "ERROR: No default compiler and was not provided with one."
        end
    else
        lmake_library.code_compiler = compiler
    end

    -- Then, see if we should add it to the list of required commands

    if not disable_compliler_check then
        table.insert(lmake_library.required_commands, lmake_library.code_compiler)
    else
        table.insert(lmake_library.lmake_flags, "disable_compliler_check")
    end

    return true

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

return lmake_library
