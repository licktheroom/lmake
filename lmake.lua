-- Copyright 2022 licktheroom

local lmake_lib = require("lmake-lib")
local version = "v0.0.1"

print("\nlmake version: "..version.."\nlmake-lib version: "..lmake_lib.version.."\nLua version: ".._VERSION.."\n")

local success, err

-- pharse command input

local lang, compiler

local input_mode = nil

for i = 1, #arg do
    if arg[i] == "--build-dir" then
        input_mode = "build-dir"
    elseif arg[i] == "--flags" then
        input_mode = "flags"
    elseif arg[i] == "--files" then
        input_mode = "files"
    elseif arg[i] == "--language" then
        input_mode = "language"
    elseif arg[i] == "--compiler" then
        input_mode = "compiler"
    elseif arg[i] == "--name" then
        input_mode = "name"
    else

        -- input modes
        if input_mode == "build-dir" then
            lmake_lib.BuildDir(arg[i])
        elseif input_mode == "flags" then
            lmake_lib.CompileFlags(false, arg[i])
        elseif input_mode == "files" then
            lmake_lib.CoreFiles(arg[i])
        elseif input_mode == "language" then
            lang = arg[i]
        elseif input_mode == "compiler" then
            compiler = arg[i]
        elseif input_mode == "name" then
            lmake_lib.ProjectName(arg[i])
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

--[[success, err = lmake_lib.LanguageAndCompiler("c", "clang")

if not success then
    print(err)
end

lmake_lib.BuildDir("build")

lmake_lib.CompileFlags(true, "-O3")

lmake_lib.ProjectName("test")

lmake_lib.CoreFiles("main.c")

success, err = lmake_lib:CheckCommands()

if not success then
    print(err)
end

success, err = lmake_lib:Compile()

if not success then
    print(err)
end]]
