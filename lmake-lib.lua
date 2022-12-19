--[[

Copyright 2022 licktheroom

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

_______________________________________________________________________________________________-

lmake is a command-line tool made in Lua used to compile code bases.

lmake.Error(func, line, str)
lmake.Assert(test, func, line, str)

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

        BuildObjects   = "BuildObjects",
        Find           = "Find"

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

        BuildObjects   = false,
        Find           = false

    }

}

lmake.Core = {

    -- include dirs
    SetIncludeDirs = function(...)
        local new = {"/usr/include/"}

        for i,v in ipairs(type(...) == "table" and ... or {...}) do

	    lmake.Assert(type(v) == "string", "SetIncludeDirs", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

	    if not string.sub(v, string.len(v)) == "/" then
                table.insert(new, v.."/")
	    else
	        table.insert(new, v)
	    end

        end

        lmake.Data.Include_dirs = new
    end,

    AddIncludeDirs = function(...)

        for i,v in ipairs(type(...) == "table" and ... or {...}) do

	    lmake.Assert(type(v) == "string", "AddIncludeDirs", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            if not string.sub(v, string.len(v)) == "/" then
                table.insert(lmake.Data.Include_dirs, v.."/")
	    else
	        table.insert(lmake.Data.Include_dirs, v)
	    end

        end

    end,

    RemoveIncludeDirs = function(...)

        for i,v in ipairs(type(...) == "table" and ... or {...}) do

            lmake.Assert(type(v) == "string", "RemoveIncludeDirs", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            if not string.sub(v, string.len(v)) == "/" then
                table.remove(lmake.Data.Include_dirs, v.."/")
	    else
	        table.remove(lmake.Data.Include_dirs, v)
	    end

	end

    end,

    -- library dirs
    SetLibraryDirs = function(...)
        local new = {"/lib/", "/usr/lib/"}

        for i,v in ipairs(type(...) == "table" and ... or {...}) do

	    lmake.Assert(type(v) == "string", "SetLibraryDirs", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            if not string.sub(v, string.len(v)) == "/" then
                table.insert(new, v.."/")
	    else
	        table.insert(new, v)
	    end

	end

        lmake.Data.Library_dirs = new
    end,

    AddLibraryDirs = function(...)

        for i,v in ipairs(type(...) == "table" and ... or {...}) do

	    lmake.Assert(type(v) == "string", "AddLibraryDirs", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            if not string.sub(v, string.len(v)) == "/" then
                table.insert(lmake.Data.Library_dirs, v.."/")
	    else
	        table.insert(lmake.Data.Library_dirs, v)
	    end
       
	end

    end,

    RemoveLibraryDirs = function(...)

        for i,v in ipairs(type(...) == "table" and ... or {...}) do

	    lmake.Assert(type(v) == "string", "RemoveLibraryDirs", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            if not string.sub(v, string.len(v)) == "/" then
                table.remove(lmake.Data.Library_dirs, v.."/")
	    else
	        table.remove(lmake.Data.Library_dirs, v)
	    end
      
	end

    end,

    -- build dir

    SetBuildDir = function(...)
        lmake.Assert(type(...) == "string", "SetBuildDir", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(...), "red"))

        lmake.Data.Build_dir = ...

        if string.sub(lmake.Data.Build_dir, string.len(lmake.Data.Build_dir)) ~= "/" then
            lmake.Data.Build_dir = lmake.Data.Build_dir.."/"
        end
    end,

    -- compiler

    SetCompiler = function(...)
        lmake.Assert(type(...) == "string", "SetCompiler", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(...), "red"))

        lmake.Data.Compiler = ...
    end,

    -- flags

    SetFlags = function(...)
        local new = {}

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
	    lmake.Assert(type(v) == "string", "SetFlags", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            table.insert(new, v)
        end

        lmake.Data.Flags = new
    end,

    AddFlags = function(...)

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
	    lmake.Assert(type(v) == "string", "AddFlags", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            table.insert(lmake.Data.Flags, v)
        end

    end,

    RemoveFlags = function(...)

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
	    lmake.Assert(type(v) == "string", "RemoveFlags", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            table.remove(lmake.Data.Flags, v)
        end

    end,

    -- files

    SetFiles = function(...)
        local new = {}

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
	    lmake.Assert(type(v) == "string", "SetFiles", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            table.insert(new, v)
        end

        lmake.Data.Files = new
    end,

    AddFiles = function(...)

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
	    lmake.Assert(type(v) == "string", "AddFiles", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            table.insert(lmake.Data.Files, v)
        end

    end,

    RemoveFiles = function(...)

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
	    lmake.Assert(type(v) == "string", "RemoveFiles", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            table.remove(lmake.Data.Files, v)
        end

    end,

    -- includes

    SetIncludes = function(...)
        local new = {}

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
	    lmake.Assert(type(v) == "string", "SetIncludes", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            table.insert(new, v)
        end

        lmake.Data.Includes = new
    end,

    AddIncludes = function(...)

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
	    lmake.Assert(type(v) == "string", "AddIncludes", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            table.insert(lmake.Data.Includes, v)
        end

    end,

    RemoveIncludes = function(...)

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
	    lmake.Assert(type(v) == "string", "RemoveIncludes", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            table.remove(lmake.Data.Includes, v)
        end

    end,

    -- language

    SetLanguage = function(...)
        lmake.Assert(type(...) == "string", "SetLanguage", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(...), "red"))

        lmake.Data.Language = string.lower(...)
    end,

    -- librarys

    SetLibrarys = function(...)
        local new = {}

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
	    lmake.Assert(type(v) == "string", "SetLibrarys", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            table.insert(new, v)
        end

        lmake.Data.Librarys = new
    end,

    AddLibrarys = function(...)

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
	    lmake.Assert(type(v) == "string", "AddLibrarys", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            table.insert(lmake.Data.Librarys, v)
        end

    end,

    RemoveLibrarys = function(...)

        for i,v in ipairs(type(...) == "table" and ... or {...}) do
	    lmake.Assert(type(v) == "string", "RemoveLibrarys", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(v), "red"))

            table.remove(lmake.Data.Librarys, v)
        end

    end,

    -- name

    SetName = function(...)
        lmake.Assert(type(...) == "string", "SetName", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(...), "red"))

        lmake.Data.Name = ...
    end,

    -- core flags

    SetCoreFlag = function(...)
        local enum = ...

        lmake.Assert(type(enum) == "number", "SetCoreFlag", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("number", "red")..", got "..io.colored(type(enum), "red"))
        lmake.Assert(lmake.Data.CoreFlags[enum] ~= nil, "SetCoreFlag", tostring(debug.getinfo(1).currentline), "Core flag "..io.colored(tostring(enum), "red").." does not exist")

        lmake.Data.CoreFlags[enum] = true
    end

}

function lmake.Error(func, line, str)
	lmake.Assert(type(func) == "string", "Error", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(func), "red"))
	lmake.Assert(type(line) == "string", "Error", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(func), "red"))
	lmake.Assert(type(str) == "string", "Error", tostring(debug.getinfo(1).currentline), "Expected "..io.colored("string", "red")..", got "..io.colored(type(func), "red"))

	print(io.colored("ERROR", "red"))
	print("In "..io.colored("function", "red").." "..io.colored(func, "yellow").." at line "..io.colored(line, "red"))
	print(str)
	os.exit()
end

function lmake.Assert(test, func, line, str)
	if not test then
		lmake.Error(func, line, str)
	end
end

function lmake.Set(datatype, ...)

    if datatype == lmake.Enum.Datatype.IncludeDirs then
        lmake.Core.SetIncludeDirs(...)
    elseif datatype == lmake.Enum.Datatype.LibDirs then
        lmake.Core.SetLibraryDirs(...)
    elseif datatype == lmake.Enum.Datatype.BuildDir then
        lmake.Core.SetBuildDir(...)
    elseif datatype == lmake.Enum.Datatype.Compiler then
        lmake.Core.SetCompiler(...)
    elseif datatype == lmake.Enum.Datatype.Flags then
        lmake.Core.SetFlags(...)
    elseif datatype == lmake.Enum.Datatype.Files then
        lmake.Core.SetFiles(...)
    elseif datatype == lmake.Enum.Datatype.Includes then
        lmake.Core.SetIncludes(...)
    elseif datatype == lmake.Enum.Datatype.Language then
        lmake.Core.SetLanguage(...)
    elseif datatype == lmake.Enum.Datatype.Librarys then
        lmake.Core.SetLibrarys(...)
    elseif datatype == lmake.Enum.Datatype.Name then
        lmake.Core.SetName(...)
    elseif datatype == lmake.Enum.Datatype.lmakeFlag then
        lmake.Core.SetCoreFlag(...)
    else
        lmake.Error("Set", tostring(debug.getinfo(1).currentline), io.colored(tostring(datatype), "red").." does not match any datatypes.")
    end

end

function lmake.Add(datatype, ...)

    if datatype == lmake.Enum.Datatype.IncludeDirs then
        lmake.Core.AddIncludeDirs(...)
    elseif datatype == lmake.Enum.Datatype.LibDirs then
        lmake.Core.AddLibraryDirs(...)
    elseif datatype == lmake.Enum.Datatype.BuildDir then
        lmake.Error("Add", tostring(debug.getinfo(1).currentline), io.colored("Build_dir", "yellow").." cannot be added to, only set.")
    elseif datatype == lmake.Enum.Datatype.Compiler then
        lmake.Error("Add", tostring(debug.getinfo(1).currentline), io.colored("Compiler", "yellow").." cannot be added to, only set.")
    elseif datatype == lmake.Enum.Datatype.Flags then
        lmake.Core.AddFlags(...)
    elseif datatype == lmake.Enum.Datatype.Files then
        lmake.Core.AddFiles(...)
    elseif datatype == lmake.Enum.Datatype.Includes then
        lmake.Core.AddIncludes(...)
    elseif datatype == lmake.Enum.Datatype.Language then
        lmake.Error("Add", tostring(debug.getinfo(1).currentline), io.colored("Language", "yellow").." cannot be added to, only set.")
    elseif datatype == lmake.Enum.Datatype.Librarys then
        lmake.Core.AddLibrarys(...)
    elseif datatype == lmake.Enum.Datatype.Name then
        lmake.Error("Add", tostring(debug.getinfo(1).currentline), io.colored("Name", "yellow").." cannot be added to, only set.")
    elseif datatype == lmake.Enum.Datatype.lmakeFlag then
        lmake.Error("Add", tostring(debug.getinfo(1).currentline), io.colored("lmakeFlag", "yellow").." cannot be added to, only set.")
    else
        lmake.Error("Add", tostring(debug.getinfo(1).currentline), io.colored(tostring(datatype), "red").." does not match any datatyes.")
    end

end

function lmake.Remove(datatype, ...)

    if datatype == lmake.Enum.Datatype.IncludeDirs then
        lmake.Core.RemoveIncludeDirs(...)
    elseif datatype == lmake.Enum.Datatype.LibDirs then
        lmake.Core.RemoveLibraryDirs(...)
    elseif datatype == lmake.Enum.Datatype.BuildDir then
        lmake.Error("Remove", tostring(debug.getinfo(1).currentline), io.colored("Build_dir", "yellow").." cannot be remove, only set.")
    elseif datatype == lmake.Enum.Datatype.Compiler then
        lmake.Error("Remove", tostring(debug.getinfo(1).currentline), io.colored("Compiler", "yellow").." cannot be removed, only set.")
    elseif datatype == lmake.Enum.Datatype.Flags then
        lmake.Core.RemoveFlags(...)
    elseif datatype == lmake.Enum.Datatype.Files then
        lmake.Core.RemoveFiles(...)
    elseif datatype == lmake.Enum.Datatype.Includes then
        lmake.Core.RemoveIncludes(...)
    elseif datatype == lmake.Enum.Datatype.Language then
        lmake.Error("Remove", tostring(debug.getinfo(1).currentline), io.colored("Language", "yellow").." cannot be removed, only set.")
    elseif datatype == lmake.Enum.Datatype.Librarys then
        lmake.Core.AddLibrarys(...)
    elseif datatype == lmake.Enum.Datatype.Name then
        lmake.Error("Remove", tostring(debug.getinfo(1).currentline), io.colored("Name", "yellow").." cannot be removed, only set.")
    elseif datatype == lmake.Enum.Datatype.lmakeFlag then
        lmake.Error("Remove", tostring(debug.getinfo(1).currentline), io.colored("lmakeFlag", "yellow").." cannot be removed, only set.") -- maybe i should make this set a flag to false
    else
        lmake.Error("Remove", tostring(debug.getinfo(1).currentline), io.colored(tostring(datatype), "red").." does not match any datatypes.")
    end

end

function lmake.Compile()
    lmake.BasicData()
    lmake.Check()

    print("Compiling...")

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

    if lmake.Data.CoreFlags.BuildObjects then
        for i,v in ipairs(lmake.Data.Files) do
	    print("Compiling "..io.colored(v, "cyan"))
            local out = io.popen(ccommand.." -c -o "..v..".o "..v, os.clock())

            lmake.Assert(out == "", "Compile", tostring(debug.getinfo(1).currentline), out)
        end

        ccommand = ccommand.." -o "..lmake.Data.Build_dir..lmake.Data.Name

        for i,v in ipairs(lmake.Data.Files) do
            ccommand = ccommand.." "..v..".o"
        end

        print("Compiling all files")

        local out = io.popen(ccommand, os.clock())

        lmake.Assert(out == "", "Compile", tostring(debug.getinfo(1).currentline), out)

    else
        ccommand = ccommand.." -o "..lmake.Data.Build_dir..lmake.Data.Name

        for i,v in ipairs(lmake.Data.Files) do
            ccommand = ccommand.." "..v
        end

        print("Compiling all files")

        local out = io.popen(ccommand, os.clock())

        lmake.Assert(out == "", "Compile", tostring(debug.getinfo(1).currentline), out)
    end
end

function lmake.BasicData()
    lmake.Assert(#lmake.Data.Files > 0, "BasicData", tostring(debug.getinfo(1).currentline), "No files were given.")
    lmake.Assert(lmake.Data.Compiler or lmake.Data.Language, "BasicData", tostring(debug.getinfo(1).currentline), "Was not given a compiler.")

    if lmake.Data.Compiler == nil then

	print(io.colored("No compiler was given, trying compiler based on language", "yellow"))
        if lmake.Data.Language == "c" then
            lmake.Data.Compiler = "gcc"
        elseif lmake.Data.Language == "c++" then
            lmake.Data.Compiler = "g++"
        else
            lmake.Error("BasicData", tostring(debug.getinfo(1).currentline), "No default compiler known for lang "..lmake.Data.Language)
        end

    end

    if lmake.Data.Build_dir == nil then

	print(io.colored("No Build_dir was given, assuming ./", "yellow"))
        lmake.Data.Build_dir = "./"

    end

    if lmake.Data.Name == nil then

	print(io.colored("No Name was given, assuming executable", "yellow"))
        lmake.Data.Name = "Executable"

    end
end

function lmake.Check()
    -- commands
    print("Finding commands...")
    if lmake.Data.CoreFlags.Find then
	
	io.write("Checking for "..io.colored("ls", "cyan").."... ")

        if string.match(io.popen("ls", os.clock()), "not") then
	    io.write(io.colored("Not found", "red").."\nChecking for "..io.colored("dir", "cyan").."... ")
            lmake.Assert(string.match(io.popen("dir", os.clock()), "not") == nil, "Check", tostring(debug.getinfo(1).currentline), "No list command.")

	    print(io.colored("Found", "green"))

            lmake.Commands.ListCommand = "dir"
        else
	    print(io.colored("Found", "green"))
            lmake.Commands.ListCommand = "ls"
        end

    end

    lmake.Assert(string.match(io.popen(lmake.Data.Compiler.." -v", os.clock()), "not") == nil, "Compiler does not exist.")
    -- files
    print("Finding files...")

    if lmake.Data.CoreFlags.Find then

        for i,v in ipairs(lmake.Data.Files) do

	    io.write("Checking "..io.colored(v, "cyan").." ")

            if string.match(io.popen(lmake.Commands.ListCommand.." "..v, os.clock()), "cannot") then
		print(io.colored("Not found", "red"))
                lmake.Error("Check", tostring(debug.getinfo(1).currentline), "File \""..v.."\" does not exist.")
            end

	    print(io.colored("Found", "green"))

        end

        for i,v in ipairs(lmake.Data.Library_dirs) do

	    io.write("Checking "..io.colored(v, "cyan").." ")

            if string.match(io.popen(lmake.Commands.ListCommand.." "..v, os.clock()), "cannot") then
		print(io.colored("Not found", "red"))
                lmake.Error("Check", tostring(debug.getinfo(1).currentline), "Library directory \""..v.."\" does not exist.")
            end

	    print(io.colored("Found", "green"));

        end

        for i,v in ipairs(lmake.Data.Include_dirs) do

	    io.write("Checking "..io.colored(v, "Cyan").." ")

            if string.match(io.popen(lmake.Commands.ListCommand.." "..v, os.clock()), "cannot") then
		print(io.colored("Not found", "red"))
                lmake.Error("Check", tostring(debug.getinfo(1).currentline), "Include directory \""..v.."\" does not exist.")
            end

	    print(io.colored("Found", "green"))

        end

        -- check libs
        if #lmake.Data.Librarys > 0 then
	    local found = {}

            for i,v in ipairs(lmake.Data.Library_dirs) do
                local cache = io.popen(lmake.Commands.ListCommand.." "..v, os.clock())

		print("Checking for librarys in "..io.colored(v, "cyan"))

                for a,d in ipairs(lmake.Data.Librarys) do

		    if string.match(cache, "lib"..d..".so") and not table.find(found, d) then
			    table.insert(found, d)
		    end

                end
            end

	    if #lmake.Data.Librarys != #found then
		    local not_found = {}

		    for i,v in ipairs(lmake.Data.Librarys) do
			    if not table.find(found, v) then
				    table.insert(not_found, v)
			    end
		    end

		    local str = "Could not find librarys:\n"

		    for i,v in ipairs(not_found) do
			    str = str..io.colored(v.."\n", "red")
		    end

		    lmake.Error("Check", tostring(debug.getinfo(1).currentline), str)
	    end
        end

    end
end

return lmake
