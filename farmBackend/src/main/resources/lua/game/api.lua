local commands = {
    get = "GET",
    buy = "BUY",
    sell = "SELL",
    apply = "APPLY",
    assign = "ASSIGN",
    move = "MOVE"
};

function setState(dataString)
    local data = json.parse(dataString)
    bag = Bag(data.bag)
    farm = Farm(data.farm)
    shop = Shop()
end

function getDataAsString()

    return json.stringify({
        staticData = staticData.getItems(),
        workers = workers,
        bag = bag.getCopyOfAllItems(),
        farm = farm.getOriginalFarmCells(),
        shop = shop.getCopyOfAllItems()
    })
end

function commandHandler(requestString)
    local requestArray = json.parse(requestString)

    if type(requestArray) ~= "table" then
        error("API didn't recognised request array: " .. requestString)
    end

    for _, requestObject in pairs(requestArray) do
        if requestObject.command == commands.get then
            return getDataAsString()
--        elseif requestObject.command == commands.buy then
--            shop.buy(requestObject.hand.id)
--        elseif requestObject.command == commands.sell then
--            shop.sell(requestObject.hand.id)
--        elseif requestObject.command == commands.apply then
--            requestObject.target.row = requestObject.target.row + 1 -- lua arrays start from 1
--            requestObject.target.col = requestObject.target.col + 1 -- lua arrays start from 1
--            farm.applyHandToCell(requestObject.hand, requestObject.target)
        elseif requestObject.command == commands.move then
            local w = utils.findInArray(workers, function(it) return it.id == requestObject.workerId end)
            if not w then error ("Worker with id "..json.stringify(requestObject.workerId).." not found") end
            if not requestObject.direction then error ("Direction is not defined") end
            w:move(requestObject.direction)
        else
            error ("Unreckognized request object: "..json.stringify(requestObject))
        end
    end

    return getDataAsString()
end

setState("{}")