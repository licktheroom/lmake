-- Copyright 2022 licktheroom

local lmake_lib = require("lmake-lib")
local version = "v0.0.1"

print("\nlmake version: "..version.."\nlmake-lib version: "..lmake_lib.version.."\nLua version: ".._VERSION.."\n")

local success, err

-- pharse command input

local lmake_flags = {"c-build-objects", "c-shared-library", "dont-find"}

local lang, compiler, input_mode

local function TableFind(table, search)
    -- loop through and see if table has a given value
    for i,v in ipairs(table) do
        if v == search then
            return i
        end
    end

    return nil
end

for i = 1, #arg do
    if string.sub(arg[i], 0, 2) == "--" then

        local opt = string.sub(arg[i], 3)

        if not TableFind(lmake_flags, opt) then

            input_mode = opt

        else

            lmake_lib.SetFlags(opt)

        end

    else

        -- input modes
        if input_mode == "include-dirs" then
            lmake_lib.AddIncludeDirectorys(arg[i])
        elseif input_mode == "lib-dirs" then
            lmake_lib.AddLibraryDirectorys(arg[i])
        elseif input_mode == "build-dir" then
            lmake_lib.BuildDir(arg[i])
        elseif input_mode == "flags" then
            lmake_lib.CompileFlags(false, arg[i])
        elseif input_mode == "files" then
            lmake_lib.CoreFiles(arg[i])
        elseif input_mode == "includes" then
            lmake_lib.IncludeFiles(arg[i])
        elseif input_mode == "language" then
            lang = arg[i]
        elseif input_mode == "compiler" then
            compiler = arg[i]
        elseif input_mode == "librarys" then
            lmake_lib.LibraryFiles(arg[i])
        elseif input_mode == "name" then
            lmake_lib.ProjectName(arg[i])
        else
            error("Stray option.")
        end

    end
end

-- continue

success, err = lmake_lib.LanguageAndCompiler(lang, compiler)

if not success then
    error(err)
    os.exit()
end

success, err = lmake_lib:CheckCommands()

if not success then
    error(err)
    os.exit()
end

success, err = lmake_lib:Compile()

if not success then
    error(err)
    os.exit()
end
