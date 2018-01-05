function Caravan(initializer)
    initializer.type = 'caravan'
    local it = Item(initializer)
    it.orders = {}
    if type(initializer.orders) ~= "table" or #initializer.orders == 0 then
        error("Caravan can't be initialized with empty orders array")
    end
    for _, orderData in pairs(initializer.orders) do
        if not orderData.itemId then
            error("Order data is invalid: item id is not present")
        end
        if not orderData.countFrom or not orderData.countTo then
            error ("Order data is invalid: count from or count to is not set")
        end
        local order = {
            itemId = orderData.itemId,
            requiredCount = math.random(orderData.countFrom, orderData.countTo),
            currentCount = 0
        }
        table.insert(it.orders, order)
    end

    it.rewards = {}
    if type(initializer.rewards) ~= "table" then
        error("Caravan can't be initialized without rewards array")
    end
    for _, rewardData in pairs(initializer.rewards) do
        if not rewardData.itemId or not rewardData.count then
            error ("Order data is invalid: itemId or reward count is not set")
        end
        local reward = {
            itemId = rewardData.itemId,
            count = rewardData.count
        }
        table.insert(it.rewards, reward)
    end

    it.isReady = function(self)
        for _, order in pairs(self.orders) do
            if order.currentCount < order.requiredCount then
                return false
            end
        end
        return true
    end

    it.use = function(farm, worker, target)
        if not worker.hand or worker.hand.id ~= pickableObjects.tools.items.basket then
            error ("Invalid worker hand: "..json.stringify(worker.hand))
        end
        local caravan = farm.cells[target.row][target.col].caravan
        local removeIndexes = {}
        for basketItemIndex, basketItem in pairs(worker.hand.objects) do
            for _, order in pairs(caravan.orders) do
                if basketItem.id == order.itemId and order.currentCount < order.requiredCount then
                    order.currentCount = order.currentCount + 1
                    table.insert(removeIndexes, basketItemIndex)
                end
            end
        end
        for i=#removeIndexes, 1, -1 do --reverse order is important
            table.remove(worker.hand.objects, removeIndexes[i])
        end
        return { farm = farm, worker = worker }
    end

    return it
end