#!/usr/bin/env lua
io.write("Hello, world!\n")



function fibo(n)
    local a, b = 0, 1
    for i = 1, n do
        a, b = b, a+b
    end
    return a
end

io.write("Fibonacci numbers\n")
io.write("\n")
for i = 0, 17 do
    io.write("F("..i..") = "..fibo(i).."\n")
end


function square(n)
    return n*n
end

print(square(5))

function squareCube(n)
    return n*n, n*n*n -- can return multiple items!
end

s, c = squareCube(5)
print(s, c)

function foo(a, b, c)
    if c == nil then
        print("c not passed")
    end
    print(a, b, c)
end

foo(1, 2)
foo(1, 2, 3)
foo(1, 2, nil) 
