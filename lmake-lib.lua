--[[

Copyright 2022 licktheroom

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

_______________________________________________________________________________________________-

lmake is a command-line tool made in Lua used to compile code bases.

lmake.Set(datatype, ...)
lmake.Add(datatype, ...)
lmake.Remove(datatype, ...)

lmake.Compile()
lmake.BasicData()
lmake.Check()
--]]

local lmake = {}

lmake.Enum = {
    Datatype = {
        IncludeDirs = 1,
        LibDirs     = 2,
        BuildDir   = 3,
        Compiler    = 4,
        Flags       = 5,
        Files       = 6,
        Includes    = 7,
        Language    = 8,
        Librarys    = 9,
        Name        = 10,
        lmakeFlag   = 11
    },

    CoreFlags = {

        BuildObjects   = 1,
        Find           = 2
        --Verbose = 3

    }
}

lmake.Commands = {

    ListCommand = nil

}

lmake.Data = {

    Include_dirs = {"/usr/include/"},
    Library_dirs = {"/lib/", "/usr/lib/"},
    Build_dir    = nil,
    Compiler     = nil,
    Flags        = {},
    Files        = {},
    Includes     = {},
    Librarys     = {},
    Language     = nil,
    Name         = nil,

    CoreFlags = {

        [lmake.Enum.CoreFlags.BuildObjects]   = false,
        [lmake.Enum.CoreFlags.Find]           = false
        --[lmake.Enum.CoreFlags.Verbose] = false,

    }

    Constant = {

        Include_dirs = false,
        Library_dirs = false,
        Build_dir    = false,
        Compiler     = false,
        Flags        = false,
        Files        = false,
        Includes     = false,
        Librarys     = false,
        Language     = false,
        Name         = false

    }

}

lmake.Core = {

    -- include dirs
    SetIncludeDirs = function(...)
        local new = {"/usr/include/"}

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.insert(new, v)
        end

        lmake.Data.Include_dirs = new
    end,

    AddIncludeDirs = function(...)
        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.insert(lmake.Data.Include_dirs, v)
        end
    end,

    RemoveIncludeDirs = function(...)
        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.remove(lmake.Data.Include_dirs, v)
        end
    end,

    -- library dirs
    SetLibraryDirs = function(...)
        local new = {"/lib/", "/usr/lib/"}

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.insert(new, v)
        end

        lmake.Data.Library_dirs = new
    end,

    AddLibraryDirs = function(...)
        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.insert(lmake.Data.Library_dirs, v)
        end
    end,

    RemoveLibraryDirs = function(...)
        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.remove(lmake.Data.Library_dirs, v)
        end
    end,

    -- build dir

    SetBuildDir = function(...)
        assert(type(...) == "string", "Expected string, got "..type(...))

        lmake.Data.Build_dir = ...

        if string.sub(lmake.Data.Build_dir, string.len(lmake.Data.Build_dir)) ~= "/" then
            make.Data.Build_dir = lmake.Data.Build_dir.."/"
        end
    end,

    -- compiler

    SetCompiler = function(...)
        assert(type(...) == "string", "Expected string, got "..type(...))

        lmake.Data.Compiler = ...
    end,

    -- flags

    SetFlags = function(...)
        local new = {}

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.insert(new, v)
        end

        lmake.Data.Flags = new
    end,

    AddFlags = function(...)
        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.insert(lmake.Data.Flags, v)
        end
    end,

    RemoveFlags = function(...)
        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.remove(lmake.Data.Flags, v)
        end
    end,

    -- files

    SetFiles = function(...)
        local new = {}

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.insert(new, v)
        end

        lmake.Data.Files = new
    end,

    AddFiles = function(...)
        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.insert(lmake.Data.Files, v)
        end
    end,

    RemoveFiles = function(...)
        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.remove(lmake.Data.Files, v)
        end
    end,

    -- includes

    SetIncludes = function(...)
        local new = {}

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.insert(new, v)
        end

        lmake.Data.Includes = new
    end,

    AddIncludes = function(...)
        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.insert(lmake.Data.Includes, v)
        end
    end,

    RemoveIncludes = function(...)
        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.remove(lmake.Data.Includes, v)
        end
    end,

    -- language

    SetLanguage = function(...)
        assert(type(...) == "string", "Expected string, got "..type(...))

        lmake.Data.Language = string.lower(...)
    end,

    -- librarys

    SetLibrarys = function(...)
        local new = {}

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.insert(new, v)
        end

        lmake.Data.Librarys = new
    end,

    AddLibrarys = function(...)
        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.insert(lmake.Data.Librarys, v)
        end
    end,

    RemoveLibrarys = function(...)
        for i,v in ipairs(type(...) == "table" and ... or {...}) do
            table.remove(lmake.Data.Librarys, v)
        end
    end,

    -- name

    SetName = function(...)
        assert(type(...) == "string", "Expected string, got "..type(...))

        lmake.Data.Name = ...
    end,

    -- core flags

    SetCoreFlag = function(...)
        local enum = ...

        assert(type(enum) == "number", "Expected number, got "..type(enum))
        assert(lmake.Data.CoreFlags[enum] ~= nil, "Core flag \""..enum.."\" does not exist")

        lmake.Data.CoreFlags[enum] = true
    end

}

function lmake.Set(datatype, ...)

    if datatype == lmake.Enum.Datatype.IncludeDirs then
        lmake.Core.SetIncludeDirs(...[1], ...)
    elseif datatype == lmake.Enum.Datatype.LibDirs then
        lmake.Core.SetLibraryDirs(...[1], ...)
    elseif datatype == lmake.Enum.Datatype.BuildDir then
        lmake.Core.SetBuildDir(...[1], ...)
    elseif datatype == lmake.Enum.Datatype.Compiler then
        lmake.Core.SetCompiler(...[1], ...)
    elseif datatype == lmake.Enum.Datatype.Flags then
        lmake.Core.SetFlags(...[1], ...)
    elseif datatype == lmake.Enum.Datatype.Files then
        lmake.Core.SetFiles(...[1], ...)
    elseif datatype == lmake.Enum.Datatype.Includes then
        lmake.Core.SetIncludes(...[1], ...)
    elseif datatype == lmake.Enum.Datatype.Language then
        lmake.Core.SetLanguage(...[1], ...)
    elseif datatype == lmake.Enum.Datatype.Librarys then
        lmake.Core.SetLibrarys(...[1], ...)
    elseif datatype == lmake.Enum.Datatype.Name then
        lmake.Core.SetName(...[1], ...)
    elseif datatype == lmake.Enum.Datatype.lmakeFlag then
        lmake.Core.SetCoreFlag(...)
    else
        error("Unknown Enum \""..datatype.."\" does not match any datatyes.")
    end

end

function lmake.Add(datatype, ...)

    if datatype == lmake.Enum.Datatype.IncludeDirs then
        lmake.Core.AddIncludeDirs(...)
    elseif datatype == lmake.Enum.Datatype.LibDirs then
        lmake.Core.AddLibraryDirs(...)
    elseif datatype == lmake.Enum.Datatype.BuildDir then
        error("Build dir cannot be added to, only set.")
    elseif datatype == lmake.Enum.Datatype.Compiler then
        error("Compilers cannot be added, only set.")
    elseif datatype == lmake.Enum.Datatype.Flags then
        lmake.Core.AddFlags(...)
    elseif datatype == lmake.Enum.Datatype.Files then
        lmake.Core.AddFiles(...)
    elseif datatype == lmake.Enum.Datatype.Includes then
        lmake.Core.AddIncludes(...)
    elseif datatype == lmake.Enum.Datatype.Language then
        error("Languages cannot be added, only set.")
    elseif datatype == lmake.Enum.Datatype.Librarys then
        lmake.Core.AddLibrarys(...)
    elseif datatype == lmake.Enum.Datatype.Name then
        error("Name cannot be added to, only set.")
    elseif datatype == lmake.Enum.Datatype.lmakeFlag then
        error("lmake flags cannot be added to, only set.")
    else
        error("Unknown Enum \""..datatype.."\" does not match any datatyes.")
    end

end

function lmake.Remove(datatype, ...)

    if datatype == lmake.Enum.Datatype.IncludeDirs then
        lmake.Core.RemoveIncludeDirs(...)
    elseif datatype == lmake.Enum.Datatype.LibDirs then
        lmake.Core.RemoveLibraryDirs(...)
    elseif datatype == lmake.Enum.Datatype.BuildDir then
        error("Build dir cannot be remove, only set.")
    elseif datatype == lmake.Enum.Datatype.Compiler then
        error("Compilers cannot be removed, only set.")
    elseif datatype == lmake.Enum.Datatype.Flags then
        lmake.Core.RemoveFlags(...)
    elseif datatype == lmake.Enum.Datatype.Files then
        lmake.Core.RemoveFiles(...)
    elseif datatype == lmake.Enum.Datatype.Includes then
        lmake.Core.RemoveIncludes(...)
    elseif datatype == lmake.Enum.Datatype.Language then
        error("Languages cannot be removed, only set.")
    elseif datatype == lmake.Enum.Datatype.Librarys then
        lmake.Core.AddLibrarys(...)
    elseif datatype == lmake.Enum.Datatype.Name then
        error("Name cannot be removed, only set.")
    elseif datatype == lmake.Enum.Datatype.lmakeFlag then
        error("lmake flags cannot be removed, only set.") -- maybe i should make this set a flag to false
    else
        error("Unknown Enum \""..datatype.."\" does not match any datatyes.")
    end

end

function lmake.Compile()
    lmake.BasicData()
    lmake.Check()

    -- create command
    local ccommand = lmake.Data.Compiler

    for i,v in ipairs(lmake.Data.Flags) do
        ccommand = ccommand.." "..v
    end

    for i,v in ipairs(lmake.Data.Include_dirs) do
        ccommand = ccommand.." -I"..v
    end

    for i,v in ipairs(lmake.Data.Library_dirs) do
        ccommand = ccommand.." -L"..v
    end

    -- compile

    if lmake.Data.CoreFlags[lmake.Enum.CoreFlags.BuildObjects] then
        for i,v in ipairs(lmake.Data.Files) do
            local out = io.popen(ccommand.." -c -o "..v..".o "..v, os.clock())

            assert(out == "", "ERROR: "..out)
        end

        ccommand = ccommand.." -o "..lmake.Data.Build_dir..lmake.Data.Name

        for i,v in ipairs(lmake.Data.Files) do
            ccommand = ccommand.." "..v..".o"
        end

        print(ccommand.."\n")

        local out = io.popen(ccommand, os.clock())

        assert(out == "", "ERROR: "..out)

    else
        ccommand = ccommand.." -o "..lmake.Data.Build_dir..lmake.Data.Name

        for i,v in ipairs(lmake.Data.Files) do
            ccommand = ccommand.." "..v
        end

        print(ccommand.."\n")

        local out = io.popen(ccommand, os.clock())

        assert(out == "", "ERROR: "..out)
    end
end

function lmake.BasicData()
    assert(#lmake.Data.Files > 0, "No files were given.")
    assert(lmake.Data.Compiler or lmake.Data.Language, "Was not given a compiler.")

    if lmake.Data.Compiler == nil then
        if lmake.Data.Language == "c" then
            lmake.Data.Compiler = "gcc"
        elseif lmake.Data.Language == "c++" then
            lmake.Data.Compiler = "g++"
        else
            error("No default compiler known for lang "..lmake.Data.Language)
        end
    end

    if lmake.Data.Build_dir == nil then
        lmake.Data.Build_dir = "./"
    end

    if lmake.Data.Name == nil then
        lmake.Data.Name = "Executable"
    end
end

function lmake.Check()
    -- commands
    if lmake.Data.CoreFlags[lmake.Enum.CoreFlags.Find] then

        if string.match(io.popen("ls", os.clock()), "not") then
            assert(string.match(io.popen("dir", os.clock()), "not") == nil, "No list command.")

            lmake.Commands.ListCommand = "dir"
        else
            lmake.Commands.ListCommand = "ls"
        end

    end

    assert(string.match(io.popen(lmake.Data.Compiler.." -v", os.clock()), "not") == nil, "Compiler does not exist.")
    -- files

    if lmake.Data.CoreFlags[lmake.Enum.CoreFlags.Find] then

        for i,v in ipairs(lmake.Data.Files) do
            if string.match(io.popen(lmake.Commands.ListCommand.." "..v, os.clock()), "cannot") then
                error("File \""..v.."\" does not exist.")
            end
        end

        for i,v in ipairs(lmake.Data.Library_dirs) do
            if string.match(io.popen(lmake.Commands.ListCommand.." "..v, os.clock()), "cannot") then
                error("Library directory \""..v.."\" does not exist.")
            end
        end

        for i,v in ipairs(lmake.Data.Includes_dirs) do
            if string.match(io.popen(lmake.Commands.ListCommand.." "..v, os.clock()), "cannot") then
                error("Include directory \""..v.."\" does not exist.")
            end
        end

        -- check libs
        if #lmake.Data.Librarys > 0 then
            for i,v in ipairs(lmake.Data.Library_dirs) do
                local cache = io.popen(lmake.Commands.ListCommand.." "..v, os.clock())

                for a,d in ipairs(lmake.Data.Librarys) do
                    if not string.match(cache, "lib"..v..".so") then
                        error("Library \""..v.."\" does not exist.")
                    end
                end
            end
        end

    end
end

return lmake
