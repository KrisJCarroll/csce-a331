-- mymod.lua
-- Glenn G. Chappell
-- 1 Feb 2019
--
-- For CS F331 / CSCE A331 Spring 2019
-- Code from 2/1: Example Lua Module
-- Not a complete program


-- To use this module, do
--     mymod = require "mymod"
-- in some Lua program.
-- Then you can call, for example, function "mymod.print_with_stars".


local mymod = {}  -- Our module


-- print_with_border
-- Given message and border character, prints message using the char as
-- the border.
-- NOT EXPORTED
local function print_with_border(msg, border)
    local n = msg:len()  -- length of string msg

    local function line()
        for i = 1, n+4 do
            io.write(border)
        end
        io.write("\n")
    end

    line()
    io.write(border .. " " .. msg .. " " .. border .. "\n")
    line()
end


-- print_with_stars
-- Given message and border character, prints message surrounded by
-- stars.
-- EXPORTED
function mymod.print_with_stars(msg)
    print_with_border(msg, "*")
end


-- dog
-- Table intended to be used as a metatable. Implements the rough
-- equivalent of a C++ class, with a constructor, a data member, and
-- member functions.
--
-- The value for internal-use-only key _sound is the dog's bark sound.
-- The default value, set by the constructor is "Ruff!".

mymod.dog = {}

-- dog.__index
-- Make dog act like a class.
function mymod.dog.__index(tbl, key)
    return mymod.dog[key]
end

-- dog.new
-- Make a new "object" of the "class" dog, and return it.
-- Like a C++ constructor.
function mymod.dog.new()
    local obj = {}        -- Our "object"
    setmetatable(obj, mymod.dog)
    obj._sound = "Ruff!"  -- Default value
    return obj
end

-- dog.wag
-- Print "<wag, wag, wag>", followed by a newline.
-- This function is intended to be called via the colon operator.
--
-- Note. This function does not need to know what table it is called on.
-- So we could write it without the "self" parameter. This parameter is
-- included for consistency, so that all "member functions" can be
-- called via the colon operator.
function mymod.dog.wag(self)
    io.write("<wag, wag, wag>\n")
end

-- dog.bark
-- Print the dog's bark sound, followed by a newline.
-- This function is intended to be called via the colon operator.
function mymod.dog.bark(self)
    io.write(self._sound.."\n")
end

-- dog.setBark
-- Set the dog's bark sound to the given string.
-- This function is intended to be called via the colon operator.
function mymod.dog.setBark(self, newbark)
    self._sound = newbark
end


return mymod      -- Return the module, so client code can use it

