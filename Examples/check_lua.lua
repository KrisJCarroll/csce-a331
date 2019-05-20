#!/usr/bin/env lua
-- check_lua.lua
-- Glenn G. Chappell
-- 24 Jan 2019
--
-- For CS F331 / CSCE A331 Spring 2019
-- A Lua Program to Run
-- Used in Assignment 1, Exercise A


-- A mysterious table
k={[=[Hlk|}]=],[[hhfz]]..'phzt',"hlwmjlni"..[==[|]==]..[[ez{]],[2*2*2]
   =[=[hotzmv{]=].."t6",[2*3]=[=====[hrw]=====],[3+2]='hrqqejl',[2*2+3]
   ="hunmrgsz",[2*2]=[=[h]=]..[==[rzv]==]..[[h]]}


-- And a mysterious function
function q(z)
    local f,x,r=74,38,35
    f = f-r - x x = x - r-f r=[===[]===]
    for y = 1,z:len() do
        r = r..string.char(string.byte(z,y)-(x%9))
        f,x = x,f+x
    end
    return r
end


-- Formatted output using the function and the table entries
io.write("Here is the secret message:\n\n")
io.write(string.format([[%s %s %]]..[==[s %s %s %s %]==]..'s %s\n',
    q(k[1]),q(k[2]),q(k[3]),q(k[4]),q(k[5]),q(k[6]),q(k[7]),q(k[8])))

-- Wait for user
io.write("\nPress ENTER to quit ")
io.read("*l")

