-- evaluator.lua
-- Glenn G. Chappell
-- 1 Apr 2019
--
-- For CS F331 / CSCE A331 Spring 2019
-- Evaluator for Arithmetic Expression Represented as AST
-- Used by evalmain.lua


local evaluator = {}  -- Our module


-- Symbolic Constants for AST

local BIN_OP     = 1
local NUMLIT_VAL = 2
local SIMPLE_VAR = 3


-- Named Variables

varValues = {
    ["e"]   = 2.71828182845904523536,
    ["phi"] = 1.61803398874989484820,
    ["pi"]  = 3.14159265358979323846,
}


-- Primary Function

-- evaluator.eval
-- Takes AST in form specified in rdparser4.lua. Returns numeric value.
-- No error checking is done.
function evaluator.eval(ast)
    local result, val1, val2, op

    if ast[1] == NUMLIT_VAL then
        result = 0+ast[2]              -- string -> number conversion
    elseif ast[1] == SIMPLE_VAR then
        result = varValues[ast[2]]     -- Look up value of variable
        if result == nil then          -- Undefined var? Set to zero
            result = 0
        end
    else  -- ast[1][1] == BIN_OP (assumed)
        val1 = evaluator.eval(ast[2])  -- Evaluate left subtree
        val2 = evaluator.eval(ast[3])  -- Evaluate right subtree
        op = ast[1][2]                 -- Our binary operator
        if op == "+" then
            result = val1 + val2
        elseif op == "-" then
            result = val1 - val2
        elseif op == "*" then
            result = val1 * val2
        else  -- op == "/" (assumed)
            result = val1 / val2
        end
    end

    return result
end


-- Module Export

return evaluator

