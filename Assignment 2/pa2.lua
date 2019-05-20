-- Filename: pa2.lua
-- Author: Kristopher Carroll
-- Last Revsision Date: 2/12/2019
-- Purpose: Module for Programming Assignment 2 containing the necessary functions for pa2_test.lua to operate
-- Additional comments: Did not finish the backSubs function due to time constraints.

local pa2 = {}

function pa2.mapTable(func, table)
    newTable = {}
    for key, value in table
        newTable[key] = func(value)
    end
    return newTable
end

function pa2.concatMax(word, length)
    i = 1
    while i < length do
        if i > string.len(word) then
            io.write(str:sub(i - string.len(word), i - string.len(word)))
        else
            io.write(str:sub(i))
        end
    end
end

function pa2.collatz(k)
    local function iter(dummy1, dummy2)
        if k % 2 == 1 then
            return 3 * k + 1
        else
            return n / 2
        end
    end
    return iter, nil, nil
end

function pa2.backSubs(s)
    i = string.len(s)
    k = 0
end

return pa2