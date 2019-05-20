--[[
item -> "(" item ")"
    | thing
thing -> ID
    | "%"
--]]
function parse_item()
    if matchString("(") then
        if not parse_item() then
            return false
        end
        if not matchString(")") then
            return false
        end
        -- Construct AST here
        return true
    elseif parse_thing() then
        -- Construct AST here
        return true
    else
        return false
    end
end

--[[
item -> "(" item ")"
    | thing
thing -> ID { ("," | ":") ID }
    | "%"
    | ["*" "-"] "[" item "]"
--]]

function parse_thing()
    if matchCat(lexer.ID) then
        while true do
            if not matchString(",") and not matchString(":") then
                break
            end
            if not matchCat(lexer.ID) then
                return false
            end
        end
    elseif matchString ("%") then
        return true
    else
        if matchString("*") then
            if not matchString("-") then
                return false
            end
        end
        if not matchString("[") then
            return false
        end
        if not parse_item() then
            return false
        end
        if not matchString("]") then
            return false
        end
    end
end