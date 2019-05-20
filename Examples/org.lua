#!/usr/bin/env lua
-- org.lua
-- Glenn G. Chappell
-- 1 Feb 2019
--
-- For CS F331 / CSCE A331 Spring 2019
-- Code from 2/1 - Lua: Organization
-- Requires mymod.lua


io.write("This file contains sample code from February 1, 2019.\n")
io.write("It will execute, but it is not intended to do anything\n")
io.write("particularly useful. See the source.\n")


-- ***** Modules *****


io.write("\n*** Modules:\n")

-- A Lua *module* is a package -- the kind of thing we would make a
-- header-file/source-file combination for in C++.

-- Import ("require" in Lua-speak) a module.
mymod = require "mymod"

-- Use a function from it.
mymod.print_with_stars("Code from module 'mymod', in file mymod.lua")

-- See file mymod.lua for the module itself.


-- ***** Metatables *****


io.write("\n*** Metatables:\n")

-- A table can have a "metatable", which is used to implement various
-- things like operator overloading and handling of nonexistent keys.
-- Here we use the latter to simulate the class-object relationship
-- found in languages like C++.

-- The table to be used as a metatable
mt = {}

-- count_to
-- Prints numbers 1 to n on a single line.
function mt.count_to(n)
    for i = 1, n do
        io.write(i .. " ")
    end
    io.write("\n")
end

-- The __index entry in a table's metatable is called when a nonexistent
-- key is accessed in the table. Here we set this function to return the
-- corresponding member of the metatable.
function mt.__index(tbl, key)
    return mt[key]
end
-- Above, parameter "tbl" is the table with the missing key. Function
-- __index must take this parameter, but we do not use it here.

-- Now, mt is like a "class". We wish to make an "object": a table whose
-- metatable is mt. Let's give mt a member "new" that creates one and
-- returns it.
function mt.new()
    local t = {}
    setmetatable(t, mt)  -- mt is now the metatable of t
    t.x = 3              -- Initialize a "data member"
    return t
end

-- Now we make our table: t
t = mt.new()

-- What happens when we call member t.count_to? There is no t.count_to,
-- so the metatable will be used.
io.write('The following should print "1 2 3 4 5 6":\n  ');
t.count_to(6)

-- There is a "class" defined in mymod.lua: dog.
-- Make an "object" of that class.
fido = mymod.dog.new()

-- Call the "wag" member. (This takes the object as a parameter; for
-- more on this, see the *Colon Operator* section.)
io.write("\nFido wags:\n  ")
fido.wag(fido)


-- ***** Colon Operator *****


io.write("\n*** Colon Operator:\n")

-- Some member functions need to know the table they are called on. Lua
-- has no notion of "the current object" (e.g., "this" in C++). A
-- solution is to pass the table to the member function.
--     tabl.foo(tabl, a, b)
-- However, the above is redundant. So Lua offers shorthand:
--     tabl:foo(a, b)

function t.increment_x(self)
    self.x = self.x+1
end

t:increment_x()

-- t.x was 3. We incremented it. The following should print "4":
io.write("t.x = " .. t.x .. " (should be 4)\n")

-- The colon operator is particularly useful when using a metatable. A
-- function that is a member of the metatable of table t needs to know
-- about t if it is to access a member of t.

function mt.print_x(self)
    io.write(self.x .. "\n")
end

io.write("Another way to print t.x: ")
t:print_x()

-- All the "member functions" of dog, in module mymod, take the "object"
-- as a first parameter (even if they do not need it, for consistency).
-- So we call them all via the colon operator.

bruiser = mymod.dog.new()
bruiser:setBark("RRRROWF!!!")

fifi = mymod.dog.new()
fifi:setBark("Yip! Yip! Yip!")

io.write("\nFido barks:\n  ")
fido:bark()
io.write("Bruiser barks:\n  ")
bruiser:bark()
io.write("Fifi barks:\n  ")
fifi:bark()


-- ***** Closures *****


io.write("\n*** Closures:\n")

-- A closure is a function that carries with it (some portion of) the
-- environment it was defined. Closures offer a simple way to do some of
-- the things we might do with an object in traditional C++ OO style.

-- make_multiplier
-- Return a function (a closure) that multiplies by the given k.
function make_multiplier(k)
    function mult(x)
        return k*x
    end

    return mult
end

-- Now use the closure turned above.
times2 = make_multiplier(2)     -- Function that multiplies by 2
triple = make_multiplier(3)     -- Function that multiplies by 3
times100 = make_multiplier(100) -- Function that multiples by 100
io.write("17 times 2 is " .. times2(17) .. "\n")
io.write("25 tripled is " .. triple(25) .. "\n")
io.write("-7 times 100 is " .. times100(-7) .. "\n")

-- Think about how we might do the above in a traditional OO style. We
-- could create an object with a member function that multiplies a
-- parameter by some data member. We would set the data member to 2 or 3
-- in a constructor to get the functionality shown above. So the
-- existence of closures means we have less need for objects.


io.write("\n")
io.write("This file contains sample code from February 1, 2019.\n")
io.write("It will execute, but it is not intended to do anything\n")
io.write("particularly useful. See the source.\n")

-- Wait for user
io.write("\nPress ENTER to quit ")
io.read("*l")

