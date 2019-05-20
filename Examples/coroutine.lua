function fibo1(limit)
    local a, b = 0, 1
    while a < limit do
        coroutine.yield(a)
        a, b = b, a + b
    end
end

c = coroutine.create(fibo1)
ok, val = coroutine.resume(c, 200)
while coroutine.status(c) ~= "dead" do 
    io.write(val.." ")
    ok, val = coroutine.resume(c)
end
io.write("\n")

if not ok then
    io.write("Error in coroutine\n")
end

function fibo2(limit)
    local a, b = 0, 1
    local function iter(dummy1, dummy2)
        if a >= limit then
            return nil
        end
        local save_a = a
        a, b = b, a+b
        return save_a
    end 
    return iter, nil, nil  
end

for k in fibo2(200) do
    io.write(k.." ")
end
io.write("\n")