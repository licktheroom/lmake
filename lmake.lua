local lmake_lib = require("lmake-lib")
local version = "v0.0.1"

print("\nlmake version: "..version.."\nlmake-lib version: "..lmake_lib.version.."\nLua version: ".._VERSION.."\n")

local success, err, method, doing

local conf = io.open("lmake.conf", "r")

if not conf then

    print("lmake.conf not found.")
    os.exit()

end

local brackets_deep = 0

for v in conf:lines() do

    local first_char = string.sub(v, 0, 1)

    if not first_char == "#" and not first_char == "\n" then

        for w in string.gmatch(v, "%a+") do

            if not w == "[" and not w == "]" then

                if not method then

                    method = w

                else



                end

            elseif w == "[" then

                brackets_deep = brackets_deep + 1

            elseif w == "]" then

                brackets_deep = brackets_deep + 1

            end

        end

    end

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
