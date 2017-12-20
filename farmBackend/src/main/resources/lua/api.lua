local commands = {
    get = "GET",
    buy = "BUY",
    sell = "SELL",
    apply = "APPLY"
};

function setState(dataString)
    local data = json.decode(dataString)
    bag = Bag(data.bag)
    farm = Farm(data.farm)
    shop = Shop()
end

function getDataAsString()

    return json.encode({
        bag = bag.getCopyOfAllItems(),
        farm = farm.getOriginalFarmObject(),
        shop = shop.getCopyOfAllItems()
    })
end

function commandHandler(requestString)
    local requestArray = json.decode(requestString)

    if type(requestArray) ~= "table" then
        error("API didn't recognised request array: " .. requestString)
    end

    for _, requestObject in pairs(requestArray) do
        if requestObject.command == commands.get then
            return getDataAsString()
        elseif requestObject.command == commands.buy then
            shop.buy(requestObject.hand.id)
        elseif requestObject.command == commands.sell then
            shop.sell(requestObject.hand.id)
        elseif requestObject.command == commands.apply then
            farm.applyHandToCell(requestObject.hand, requestObject.target)
        end
    end

    return getDataAsString()
end


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

    local copy = function(t)
        if type(t) ~= "table" then return t end
        local meta = getmetatable(t)
        local target = {}
        for k, v in pairs(t) do
            if type(v) == "table" then
                target[k] = clone(v)
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

setState("{}")