local commands = {
    get = "GET",
    buy = "BUY",
    sell = "SELL",
    apply = "APPLY"
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
        bag = bag.getCopyOfAllItems(),
        farm = farm.getOriginalFarmObject(),
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

setState("{}")