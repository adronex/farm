--function get_all_factors(number)
--    --[[
--        multiline comments
--        @Parameter: number
--        nevermind
--     ]]--
--    local factors = {}
--    for possible_factor = 1, math.sqrt(number), 1 do
--        local remainder = number % possible_factor
--
--        if remainder == 0 then
--            local factor, factor_pair = possible_factor, number / possible_factor
--            table.insert (factors, factor)
--            if factor ~= factor_pair then
--                table.insert (factors, factor_pair)
--            end
--        end
--    end
--    table.sort (factors)
--    return factors
--end
--
--the_universe = 42
--factors_of_the_universe = get_all_factors(the_universe)
--
---- single-line comment
--print ("Output", "Second output string")
--
--for key, value in pairs(factors_of_the_universe) do
--    print (key, value)
-- end
---------------------------------------------------------------------
--first, second, third = "first", "second", "third"
--
--local myFunc = function(...)
--    local args = {...}
--    local msg = ""
--    for i, val in pairs(args) do
--        msg = msg..val
--    end
--    print (msg)
--end
--
--myFunc(first, second, third)
---------------------------------------------------------------------
json = require "libs/json"

print (json.decode('{"a": "j"}').a)