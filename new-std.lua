--[[

Copyright 2022 licktheroom

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

--]]

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

--]]

-- TABLE

function table.remove(t, va)

    -- Check data types
    assert(type(t) == "table", "Table expected, got "..type(t))
    assert(va, "Variable to remove is nil.")

    -- Loop through table and move every value after va down in index
    local found = false

    for i,v in ipairs(t) do

        if not found and v == va then

            found = true

        elseif found then

            t[i-1] = t[i]

        end

    end

    -- Set the final value of t to nil to remove it
    t[#t] = nil

end

function table.find(t, va)

    -- Check data types
    assert(type(t) == "table", "Table expected, got "..type(t))
    assert(va, "Variable to find is nil.")

    -- Look for va in t
    for i,v in ipairs(t) do

        if v == va then

            return i

        end
    end

    return nil

end

function table.stepped(t, start, step, finish)

    -- Check data types
    assert(type(t) == "table", "Table expected, got "..type(t))
    assert(type(start) == "number", "Number expected, got "..type(start))
    assert(step == nil or type(step) == "number", "Number or nil expected, got "..type(step))
    assert(finish == nil or type(finish) == "number", "Number or nil expected, got "..type(finish))

    -- Step through the table
    local nt = {}

    for i = start, finish and finish or #t, step and step or 1 do

        table.insert(nt, t[i])

    end

    return nt

end

function table.print(t) -- styled should be the color var, should be nil or bool

    -- Check data type
    assert(type(t) == "table", "Table expected, got "..type(t))

    -- Print the table
    -- TODO: Add colors, should only be active if the user wants it.
    io.write("{ ")

    for i,v in ipairs(t) do

        if type(v) == "table" then

            table.print(v)

        elseif type(v) == "string" then

            io.write("\""..v.."\", ")

        else

            io.write(tostring(v)..", ")

        end

    end

    io.write(" }")

end

-- IO

-- Not finished, need to check on windows
-- Well, I know it doesn't work on windows
-- I need to figure that out
function io.popen(cmd, id)

    -- Execute the command, pass output to a file
    local success, txt = os.execute(cmd.." >> "..id.." 2>&1")

    -- Open and read the entire file
    local f = io.open(id)

    local a = f:read("*a")

    f:close()

    -- Remove the file so we don't have clutter
    os.execute("rm "..id)

    return a

end
