function Utils()
    local findInArray = function(array, fun)
        for _, it in pairs(array) do
            if fun(it) then return it end
        end
        return nil
    end

    local mapArray = function(array, fun)
        local mapped = {}
        for index, it in pairs(array) do
            mapped[index] = fun(it)
        end
        return mapped
    end

    local copy = function(self, t)
        if type(t) ~= "table" then return t end
        local meta = getmetatable(t)
        local target = {}
        for k, v in pairs(t) do
            if type(v) == "table" then
                target[k] = self:copy(v)
            else
                target[k] = v
            end
        end
        setmetatable(target, meta)
        return target
    end

    return {
        findInArray = findInArray,
        mapArray = mapArray,
        copy = copy
    }
end

utils = Utils()