--[[

Copyright 2022 licktheroom

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]

--[[

table.remove(t, va)
|
| Searches for va in t and removes it from t. Moves every value after va down one.

table.find(t, va)
|
| Searches for va in t and returns where it is in t. Otherwise, fail (nil).

table.stepped(t, start, step, finish)
|
| If you know python: list[1:3:6]
| Otherwise, it starts from index start in t and steps (adds) step to start every interation until finish. Returns the new table, does not overwrite the original.
| You do not need to give step nor finish.

table.print(t)
|
| Print a table and all sub tables.

io.popen(cmd, id)
|
| Almost the same as the original, but now (should) work everywhere.
| id is required as that's what we name the generated file.

]]

-- TABLE

function table.remove(t, va)

    if type(t) ~= "table" then
        error("Table expected, was given "..type(t)..".")
    end

    if not va then
        error("Was not given a varible to remove.")
    end

    local found = false

    for i,v in ipairs(t) do

        if not found and v == va then

            found = true

        elseif found then

            t[i-1] = t[i]

        end

    end

    t[#t] = nil

end

function table.find(t, va)

    if type(t) ~= "table" then
        error("Table expected, was given "..type(t)..".")
    end

    if not va then
        error("Was not given a variable to find.")
    end

    for i,v in ipairs(t) do

        if v == va then

            return i

        end
    end

    return nil

end

function table.stepped(t, start, step, finish)

    if type(t) ~= "table" then
        error("Table expected, was given "..type(t)..".")
    end

    if type(start) ~= "number" then
        error("Number expected, was given "..type(start)..".")
    end

    if step and type(step) ~= "number" then
        error("Step is not a number")
    end

    if finish and type(finish) ~= "number" then
        error("Finish is not a number")
    end

    local nt = {}

    for i = start, finish and finish or #t, step and step or 1 do

        table.insert(nt, t[i])

    end

    return nt

end

function table.print(t)

    if type(t) ~= "table" then
        error("Table expected, was given "..type(t)..".")
    end

    io.write("{ ")

    for i,v in ipairs(t) do

        if type(v) == "table" then

            table.print(v)

        elseif type(v) == "string" then

            io.write("\""..v.."\", ")

        else

            io.write(v.." ")

        end

    end

    io.write(" }")

end

-- IO

-- Not finished, need to check on windows
function io.popen(cmd, id)

    local success, txt = os.execute(cmd.." >> "..id.." 2>&1")

    -- open and read the entire file
    local f = io.open(id)

    local a = f:read("*a")

    f:close()

    -- remove the file so we don't have clutter
    os.execute("rm "..id)

    return a

end
