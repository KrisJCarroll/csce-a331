#!/usr/bin/env lua
-- fund.lua
-- Glenn G. Chappell
-- 30 Jan 2019
--
-- For CS F331 / CSCE A331 Spring 2019
-- Code from 1/30 - Lua: Fundamentals


io.write("This file contains sample code from January 30, 2019.\n")
io.write("It will execute, but it is not intended to do anything\n")
io.write("particularly useful. See the source.\n")


-- ***** Lexical Structure *****


io.write("\n*** Lexical Structure:\n")

-- Comments
--
-- Single-line comment
--[[
Multiline
comment
--]]
--[====[Another
multiline comment]====]
               -- The number of equals signs must be the same.

-- Identifiers
-- A Lua identifier is like a "C" identifier: starts with lettter "_",
-- contains only letters, "_", and digits, and is not a keyword (and,
-- break, do, else, elseif, end, false, for, function, if, in, local,
-- nil, not, or, repeat, return, then, true, until, while).
xYz_123_BLAH = 7

-- String literals

-- Quoted strings
ss = "xyz"      -- Use single or double quotes.
ss = 'xyz'
io.write(ss.."\n")

-- Multiline strings
ss = [=[xyz]=]  -- The number of equals signs must be the same
ss = [[xyz]]    --  (as for multiline comments).
ss2 = [====[This string includes
a newline!]====]
io.write(ss.."\n")


-- ***** Variables, Values, Expressions *****


io.write("\n*** Variables, Values, Expressions:\n")

-- To make a variable, just set its value.
abc = true      -- type boolean

-- Values have types; variables are just references to values.
-- So we can set a variable to a value of a different type.
abc = 3.2       -- type number

-- Arithmetic expressions and comparisons are pretty much as usual.
bcd = (abc + 7) * 14
-- Note that the inequality operator is "~=".
bcd = (abc ~= ss)

-- We can assign multiple values at once.
x, y = abc, 4   -- Equivalent to "x = abc" and "y = 4", simultaneously
x, y = y, x     -- Easy way to swap

-- Boolean literals: true, false
-- Boolean operators: and, or, not
z = true

-- The function "print" prints things, followed by newline.
print(bcd)

-- But let's avoid using "print" for anything except quickie debugging
-- printout. io.write is nicer. It does not automatically print a
-- newline. Use the ".." operator to concatenate. Number-to-string
-- conversion is automatic, so you can do this:
io.write(-734.1 .. " " .. x+3 .. "\n")

-- Uncomment the following. When executed, a type error should be
-- flagged. But since Lua has dynamic type checking, the above output
-- will be done before the type error is flagged.

--io.write(1 / "abc")


-- ***** Functions *****


io.write("\n*** Functions:\n")

-- Lua code does not need to be inside a function. The main program is
-- simply the code at global scope.

-- Define a function using the keyword "function". This is followed by
-- the name of the function, the parameter list (no types!) and then the
-- body. End the function with "end". Braces & semicolons are not
-- necessary.
function fibo(n)  -- Return the nth Fibonacci number
    local a, b = 0, 1
    for i = 1, n do
        a, b = b, a+b
    end
    return a
end
-- Note the syntax for the for loop and return statement above. Also
-- note the "local" keyword. Most variables default to global. Make them
-- local variables as above. Parameters (like n) and loop counters (like
-- i) default to local.

-- Lua mostly does not care about newlines.
function fibo(n) local a,b=0,1 for i=1,n do a,b=b,a+b end return a end

-- Functions are called as usual.
io.write("The 8th Fibonacci number is " .. fibo(8) .. ".\n")

-- Lua has first-class functions. So a function is just another kind of
-- value. We could do it this way:
fibo = function(n)
        local a, b = 0, 1
        for i = 1, n do
            a, b = b, a+b
        end
        return a
    end

-- fibo is just a variable, whose value happens to be a function.
-- Treat it like any other variable.
fibo = 'blah blah blah'

-- A function parameter that is not passed becomes nil inside the
-- function. Check for nil using the (in)equality operator.

function numParams(a, b)
    io.write("Number of parameters passed: ")
    if b ~= nil then
        io.write(2)
    elseif a ~= nil then
        io.write(1)
    else
        io.write(0)
    end
    io.write("\n")
end

-- When passing a single argument to a function, and the argument is
-- either a string literal or a table literal, we may leave off the
-- parentheses in the function call.

function printTwice(s)
    io.write(s..s.."\n")
end

printTwice("Hello")
               -- With parentheses
printTwice "Goodbyte"
               -- Without parentheses

-- We can create functions inside functions. Use "local" to make them
-- local.

function div(a, b)
    local function doTheDivision(x, y)
        return x / y
    end
    return doTheDivision(a, b)
end

io.write("3/4 = "..div(3,4).."\n")


-- ***** Tables ******


io.write("\n*** Tables:\n")

-- Lua does maps/dictionaries, arrays, objects, and classes using a
-- single language feature: a key-value structure called a "table".

-- Table literals use braces
capitals = { ["Alaska"]="Juneau", ["Kansas"]="Topeka" }
-- Above, there are two key-value pairs. One key is "Alaska"; the
-- associated value is "Juneau".

-- Access table values using braces.
io.write(capitals['Alaska'] .. "\n")  -- Should print "Juneau".

-- Set table values similarly.
capitals["New Jersey"] = "Trenton"

-- Delete a key from a table by setting the associated value to nil.
capitals["Kansas"] = nil

-- We can mix types of keys and values.
mixed = { [1]="howdy", ["abc"]=42, ["x"]=3.2 }

-- If a key looks like an identifier, then we can use dot syntax.
io.write(mixed.abc .. "\n")  -- Prints mixed["abc"], that is, 42.

-- We can put functions in tables
function hello()
    io.write("Hello there!\n")
end
mixed.h = hello
mixed.h()  -- Function call; should print "Hello there!"

-- We can declare a function to be a table member directly
function mixed.goodbye()
    io.write("Goodbye!\n")
end
mixed.goodbye()  -- Should print "Goodbye!"

-- Iterate through the items in a table with "pairs"
tt = { [5]="abc", ['def']=4 }
for k,v in pairs(tt) do
    io.write("Key: "..k.."; value: "..v.."\n")
end


-- ***** Arrays *****


io.write("\n*** Arrays:\n")

-- We can make arrays out of tables. Indices start at ONE!
arr = { "x", 234, "lizard" }
-- Above is same as:
--     arr = { [1]="x", [2]=234, [3]="lizard" }

-- Get the size of an array by prefixing its name with a pound sign.
io.write("The size of array arr is "..#arr..".\n")
-- This is useful in loops
for i = 1, #arr do
    io.write("arr["..i.."] = "..arr[i].."\n")
end

-- Or iterate through the key-value pairs in an array using "ipairs".
-- Keys appear in order.
io.write("Again:\n")
for k,v in ipairs(arr) do
    io.write("arr["..k.."] = "..v.."\n")
end


-- ***** Flow of Control *****


io.write("\n*** Flow of control:\n")

-- if-then
if 1+1 == 2 then
    io.write("1+1 is 2\n")
end

-- if-then-else
if 4*5 ~= 30 then
    io.write("4*5 ~= 30\n")
else
    io.write("4*5 == 30\n")
end

-- also elseif (which allows us to avoid lots of "end" keywords)
if 2+3 == 3 then
    io.write("2+3 == 2\n")
elseif 2+3 == 4 then
    io.write("2+3 == 4\n")
elseif 2+3 == 5 then
    io.write("2+3 == 5\n")
else
    io.write("2+3 is some other value\n")
end

-- while-loop
i = 2
while i <= 10 do  -- Will print "2 3 4 5 6 7 8 9 10".
    io.write(i .. " ")
    i = i+1  -- There is no "+=" or "++".
end
io.write("\n")

-- repeat-loop (like do-while in C/C++/Java)
i = 2
repeat  -- Will print "2 3 4 5 6 7 8 9 10".
    io.write(i .. " ")
    i = i+1  -- There is no "+=" or "++".
until i > 10
io.write("\n")

-- for-loop, counter based
for i = 2, 10 do  -- Will print "2 3 4 5 6 7 8 9 10".
    io.write(i .. " ")
end
io.write("\n")

-- for-loop with optional step
for i = 2, 10, 3 do  -- Will print "2 5 8".
    io.write(i .. " ")
end
io.write("\n")

-- for-in-loop, iterator based
tt = { "x", ["q"]=7, "y", "z", [5]="Yo!" }
io.write("\n")
io.write("Loop #1\n")
for k, v in pairs(tt) do  -- Loops over all keys.
    io.write("key: " .. k .. "; value: " .. v .. "\n")
end
io.write("\n")
io.write("Loop #2\n")
for k, v in ipairs(tt) do  -- Loops over all keys 1, 2, 3
                           -- until one is missing.
    io.write("key: " .. k .. "; value: " .. v .. "\n")
end
-- Compare the output of the two loops above

-- We can (and eventually will) write our own iterators for use with the
-- iterator-based for-in looping structure.

-- Other flow of control: exceptions, coroutines, threads.


io.write("\n")
io.write("This file contains sample code from January 30, 2019.\n")
io.write("It will execute, but it is not intended to do anything\n")
io.write("particularly useful. See the source.\n")

-- Wait for user
io.write("\nPress ENTER to quit ")
io.read("*l")

