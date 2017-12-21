function Shop()
    local shopItems = {
        {
            item = staticData.getItems().field,
            buyPrice = 4,
            sellPrice = 1
        },
        {
            item = staticData.getItems().well,
            buyPrice = 0,
            sellPrice = 0
        },
        {
            item = staticData.getItems().wateringCan,
            buyPrice = 0,
            sellPrice = 0
        },
        {
            item = staticData.getItems().sickle,
            buyPrice = 0,
            sellPrice = 0
        },
        {
            item = staticData.getItems().wheat,
            buyPrice = 3,
            sellPrice = 1
        },
        {
            item = staticData.getItems().carrot,
            buyPrice = 15,
            sellPrice = 3
        }
    }
    local findShopItem = function(itemId)
        return utils.findInArray(shopItems, function(it)
            return it.item.id == itemId
        end)
    end

    local getCopy = function (itemId)
        local item = findShopItem(itemId)
        if not item then return nil end
        return utils:copy(item)
    end

    local getCopyOfAllItems = function()
        return utils:copy(shopItems)
    end

    local buy = function(itemId)
        local item = findShopItem(itemId)
        if not item then error ("There is no shop item with id "..itemId) end
        bag.decreaseCount(staticData.getItems().softMoney.id, item.buyPrice)
        bag.increaseCount(item.item.id, 1)
    end

    local sell = function(itemId)
        local count = bag.getOrCreate(itemId).count
        if count == 0 then
            error ("Bag doesn't contain enough items with id "..itemId)
        end
        local item = findShopItem(itemId);
        if not item then
            error ("You can't sell item with id "..itemId.."because shop doesn't contain it")
        end
        bag.decreaseCount(item.item.id, 1);
        bag.increaseCount(staticData.getItems().softMoney.id, item.sellPrice)
    end

    return {
        getCopy = getCopy,
        getCopyOfAllItems = getCopyOfAllItems,
        buy = buy,
        sell = sell
    }
end

shop = Shop()