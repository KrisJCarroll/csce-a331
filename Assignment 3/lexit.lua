-- lexit.lua
-- Kristopher Carroll
-- March 1st, 2019
-- CSCE A331 Assignment 3

-- Part A: May the Forth be with you!

-- Purpose: Take Jabroa program as an input and lex into individual lexemes to be returned
--          as a stream of lexemes for later parser to be built.
--          Example usage:
--              program = ___ -- program to lex
--              for lexstr, cat in lexer.leg(program) do
--                  -- lexstr is the string representation of lexeme in stream
--                  -- cat is a number representing lexeme category as defined in this
--                     program
--              end


-- Initializing Module Table
local lexit = {} -- module table to add members to

-- *****************************************************************************************
-- Public Constants
-- *****************************************************************************************

-- Numeric constants for associated lexeme categories
lexit.KEY = 1
lexit.ID = 2
lexit.NUMLIT = 3
lexit.STRLIT = 4
lexit.OP = 5
lexit.PUNCT = 6
lexit.MAL = 7

-- Array of corresponding human-readable lexeme categories (corresponds to constants above)
lexit.catnames = {
    "Keyword",
    "Identifier",
    "NumericLiteral",
    "StringLiteral",
    "Operator",
    "Punctuation",
    "Malformed",
}

-- *****************************************************************************************
-- Character Recognition Functions
-- *****************************************************************************************

-- Primarily adapted from lexer.lua by Glenn G. Chappell from CSCE 331 Repository
-- All functions return false if string length passed is not 1

-- is_letter
-- Returns true if c is a letter, otherwise false
local function is_letter(c)
    if c:len() ~= 1 then
        return false
    -- TODO: mostly unnecessary, combine these two checks into one
    elseif c >= "A" and c <= "Z" then -- Uppercase letters
        return true
    elseif c >= "a" and c <= "z" then -- Lowercase letters
        return true
    else
        return false
    end
end

-- is_digit
-- Returns true if c is a digit, otherwise false
local function is_digit(c)
    if c:len() ~= 1 then
        return false
    elseif c >= "0" and c <= "9" then -- character is a digit between 0-9
        return true
    else
        return false
    end
end

-- is_operator
-- Returns true if c is "+", "-", "*", or "/", false otherwise
local function is_operator(c)
    if c:len() ~= 1 then
        return false
    elseif c == "+" or c == "-" or c == "*" or c == "/" or c == "%" then
        return true
    elseif c == "!" or c == "=" or c == "&" or c == "|" or c == "[" then
        return true
    elseif c == "]" or c == "<" or c == ">" then
        return true
    else
        return false
    end
end

-- is_whitespace
-- Returns true if c is whitespace character (tab, space, newline, carriage return, 
-- page skips), false otherwise
local function is_whitespace(c)
    if c:len() ~= 1 then
        return false
    elseif c == " " or c == "\t" or c == "\n" or c == "\r" or c == "\f" then
        return true
    else
        return false
    end
end

-- is_comment
-- Returns true if c signifies a comment start character ("#"), false otherwise
local function is_comment(c)
    if c:len() ~= 1 then
        return false
    elseif c == "#" then
        return true
    else
        return false
    end
end

-- is_string
-- Returns true if c signifies the beginning of a StringLiteral with " or '
local function is_string(c)
    if c:len() ~= 1 then
        return false
    elseif c == "'" or c == '"' then
        return true
    else
        return false
    end
end

-- is_illegal
-- Returns true if c is an illegal character, false otherwise
local function is_illegal(c)
    if c:len() ~= 1 then
        return false
    elseif is_whitespace(c) then
        return false
    elseif c >= " " and c <= "~" then
        return false
    else
        return true
    end
end

-- *****************************************************************************************
-- Lexer
-- *****************************************************************************************

-- lex
-- Lexes input in the form of Jabroa code for use in a for-in loop to output a stream of
--   lexemes found in the input program
-- lex_str is the string form of the lexeme, cat is a number representation of associated
--   lexeme category

function lexit.lex(program)
    ----------- Local Variables -----------
    local pos -- index of next character in program
    local state -- current state of lexer state machine
    local chr -- current character from input
    local lex_str -- the string of the lexeme, concatenated until lexeme identified
    local category -- category of lexeme applied to lexeme when lexeme identified (state DONE)
    local handlers -- Table of handler functions, determining how to handle different characters

    ----------- States -----------
    local DONE = 0
    local START = 1
    local LETTER = 2
    local DIGIT = 3
    local OPERATOR = 4
    local EXPONENT = 5
    local STRING = 6

    ----------- Keywords -----------
    local keywords = {
        "cr",
        "def",
        "else",
        "elseif",
        "end",
        "false",
        "if",
        "readnum",
        "return",
        "true",
        "while",
        "write",
    }

    ----------- Operators -----------
    local operators = {
        "&&",
        "||",
        "!",
        "==",
        "!=",
        "<",
        "<=",
        ">",
        ">=",
        "+",
        "-",
        "*",
        "/",
        "%",
        "[",
        "]",
        "=",
    }

    ----------- Character-Related Helper Functions -----------

    -- curr_char
    -- Returns the current character at index pos in program.
    -- Values returned as single-character string or empty string if pos is indexing
    -- past the end of program
    local function curr_char()
        return program:sub(pos, pos)
    end

    -- next_char
    -- Returns the character following the character currently being processed
    -- Values returned as single-character string or empty string if pos is indexing
    -- past the end of program
    local function next_char()
        return program:sub(pos+1, pos+1)
    end

    -- skip_char
    -- Skips pos ahead to next character
    local function skip_char()
        pos = pos + 1
    end

    -- skip_comment
    -- Skips all characters following found comment character (#) until newline character
    -- and adjusts pos accordingly
    local function skip_comment()
        while curr_char() ~= "\n" and curr_char() ~= "" do
            skip_char()
        end
    end

    -- add_char
    -- Adds current character to lexeme and moves pos to next character
    local function add_char()
        lex_str = lex_str .. curr_char()
        skip_char()
    end

    -- skip_whitespace
    -- Skips all whitespace and comments, moving pos to beginning of next applicable
    -- lexeme, or to program:len()+1 (beyond end of program)
    local function skip_whitespace()
        while true do -- in whitespace
            while is_whitespace(curr_char()) do
                skip_char()
            end

            if curr_char() ~= "#" then -- next character is a lexeme, done skipping whitespace
                break
            end
            skip_char() -- Skip "#" symbol
            
            while curr_char() ~= "\n" do -- in comment
                if curr_char() == "" then
                    return
                end
                skip_char()
            end
        end
    end

    ----------- Additional Helper Functions -----------

    -- is_keyword
    -- Checks str to see if it is found in the keywords table for proper identification
    local function is_keyword(str)
        for _, v in pairs(keywords) do
            if str == v then
                return true
            end
        end

        return false
    end
    ----------- State Handling Logic Functions -----------
    -- Functions are named handle_###### with ###### being the state being handled

    -- handle_DONE
    -- Error case as the DONE state does not need to be handled
    local function handle_DONE()
        io.write("ERROR: 'DONE' state should not be handled\n")
        assert(0)
    end

    -- handle_START
    -- Determines the appropriate actions and state changes for START state
    local function handle_START()
        previous_exponent = false
        if ch == "_" or is_letter(ch) then -- potential Key-or-Identifer found
            add_char()
            state = LETTER
        elseif is_digit(ch) then -- check for digit
            state = DIGIT -- not certain if part of lexeme yet, don't add
        elseif is_operator(ch) then -- check for operator
            state = OPERATOR
        elseif is_comment(ch) then -- check for comment
            skip_whitespace()
        elseif is_string(ch) then -- check for StringLiteral
            state = STRING
        elseif is_illegal(ch) then -- Check for illegal character in lexeme 
            add_char()
            state = DONE
            category = lexit.MAL
        else -- all else is punctuation, add to lexeme, move to DONE state, assign category
            add_char()
            state = DONE
            category = lexit.PUNCT
        end
    end

    -- handle_LETTER
    -- Determines the appropriate actions and state changes for character handling after
    -- reading a letter or underscore
    local function handle_LETTER()
        if ch == "_" or is_letter(ch) or is_digit(ch) then -- still part of identifier
            add_char()
        else -- end of key or identifier/beginning of next lexeme
            state = DONE
            if is_keyword(lex_str) then -- check for keyword
                category = lexit.KEY
            else -- otherwise, identifier
                category = lexit.ID    
            end
        end
    end

    -- handle_DIGIT
    -- Determines appropriate actions and state changes for character handling after
    -- reading a digit
    local function handle_DIGIT()
        if is_digit(ch) then -- number continues
            add_char()
        elseif ch == "." then -- decimal found
            state = DONE
            category = lexit.NUMLIT
        elseif ch == "e" or ch == "E" then
            state = EXPONENT
        else -- end of digit containing lexeme, set state to DONE and apply NUMLIT category
            state = DONE
            category = lexit.NUMLIT
        end
    end

    -- handle_OPERATOR
    -- Determines appropriate actions and state changes for character handling after reading a 
    -- starting operator
    local function handle_OPERATOR()
        -- Handling for "+" and "-", which have special considerations as a potential operator
        if ch == "+" or ch == "-" then
            if pos == 1 then
                add_char()
                if is_digit(curr_char()) then -- Check if followed by digit
                    add_char() -- add digit to lex_str
                    state = DIGIT
                    return
                else
                    state = DONE
                    category = lexit.OP
                    return
                end
            end
            if category == lexit.ID or category == lexit.NUMLIT then -- identifies operator lexeme syntax
                add_char()
                state = DONE
                category = lexit.OP
            elseif prev_lex == ")" or prev_lex == "]" then -- identifies other operator lexeme syntax
                add_char()
                state = DONE
                category = lexit.OP
            elseif prev_lex == "true" or prev_lex == "false" then -- identifies last operator lexeme syntax
                add_char()
                state = DONE
                category = lexit.OP
            elseif is_digit(next_char()) then -- check for digit, proper digit format
                add_char()
                add_char()
                state = DIGIT
            else
                add_char()
                state = DONE
                category = lexit.OP
            end
        -- Handling && operator
        elseif ch == "&" then
            add_char()
            if curr_char() == "&" then
                add_char()
                state = DONE
                category = lexit.OP
            else
                state = DONE
                category = lexit.PUNCT
            end
        -- Handling || operator
        elseif ch == "|" then
            add_char()
            if curr_char() == "|" then
                add_char()
                state = DONE
                category = lexit.OP
            else
                state = DONE
                category = lexit.PUNCT
            end
        -- Handling operators that may optionally end with additiona "="
        elseif ch == "<" or ch == ">" or ch == "=" or ch == "!" then
            add_char()
            if curr_char() == "=" then
                add_char()
                state = DONE
                category = lexit.OP
            else
                state = DONE
                category = lexit.OP
            end
        
        else
            add_char()
            state = DONE
            category = lexit.OP
        end
    end

    -- handle_EXPONENT
    -- Determines appropriate actions and state changes for character handling after reading an
    -- exponent identifier in a NumericLiteral
    local function handle_EXPONENT()
        if previous_exponent then -- already encountered an exponent in current lexeme
            state = DONE
            category = lexit.NUMLIT
            return
        end
        previous_exponent = true
        if is_digit(next_char()) then -- correctly formatted exponent
            add_char() -- add exponent
            add_char() -- add digit
            state = DIGIT
        elseif next_char() == "+" then -- only other valid following character
            if pos == program:len() - 1 then -- if "+" is the end of input, ignore exponent
                state = DONE
                category = lexit.NUMLIT
                return
            else -- "+" not at end
                add_char() -- add exponent to check ahead
                if is_digit(next_char()) then -- check for digits following "+"
                    add_char()
                    add_char()
                    state = DIGIT
                else -- no digits following "+", revert back
                    lex_str = lex_str:sub(1, lex_str:len() - 1)
                    pos = pos - 1
                    state = DONE
                    category = lexit.NUMLIT
                end
            end
        else -- no other valid options
            state = DONE
            category = lexit.NUMLIT
        end
    end
            
    -- handle_STRING
    -- Determines appropriate actions and state changes for character handling when a signifier
    -- of a StringLiteral is found
    local function handle_STRING()
        if ch == "'" then
            add_char() -- add opening quote
            while curr_char() ~= "'" do
                if curr_char() == "\n" then -- newline before finding matching pair
                    add_char()
                    state = DONE
                    category = lexit.MAL
                    return
                elseif curr_char() == "" then -- end of input before finding matching pair
                    state = DONE
                    category = lexit.MAL
                    return
                else -- add everything else and continue
                    add_char()
                end
            end
            add_char() -- add closing quote
            state = DONE
            category = lexit.STRLIT
        elseif ch == '"' then
            add_char() -- add opening quote
            while curr_char() ~= '"' do
                if curr_char() == "\n" then -- newline before finding matching pair
                    add_char()
                    state = DONE
                    category = lexit.MAL
                    return
                elseif curr_char() == "" then -- end of input before finding matching pair
                    state = DONE
                    category = lexit.MAL
                    return
                else -- add everything else and continue
                    add_char()
                end
            end
            add_char() -- add closing quote
            state = DONE
            category = lexit.STRLIT
        end
    end

    ----------- Table of State-Handler Functions -----------
    local handlers = {
        [DONE] = handle_DONE,
        [START] = handle_START,
        [LETTER] = handle_LETTER,
        [DIGIT] = handle_DIGIT,
        [OPERATOR] = handle_OPERATOR,
        [EXPONENT] = handle_EXPONENT,
        [STRING] = handle_STRING,
        }

    ----------- Iterator Function -----------
    -- get_lexeme
    -- Called each time iterated in the for-in loop
    -- Returns a pair of lex_str (string) and category (int)
    -- Returns nil, nil if no more lexemes in program
    local function get_lexeme(dummy1, dummy2)
        if pos > program:len() then -- no more lexemes in program
            return nil, nil
        end
        lex_str = ""
        state = START
        while state ~= DONE do
            ch = curr_char()
            handlers[state]()
        end
        prev_lex = lex_str
        prev_category = category
        skip_whitespace() -- skip whitespace between lexemes, if any
        return lex_str, category
    end

    ----------- Body of lex -----------
    pos = 1 -- initialize position to beginning of program
    ch = curr_char()
    skip_whitespace() -- ignore all starting whitespace
    return get_lexeme, nil, nil -- return the pair from get_lexeme and two dummy nil values
end

return lexit