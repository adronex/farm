-- DEPRECATED
function Shop()
    local shopItems = {
        {
            item = groundObjects.factories.items.well,
            buyPrice = 0,
            sellPrice = 0
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
        bag.decreaseCount(inventoryObjects.currencies.items.softMoney, item.buyPrice)
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
        bag.increaseCount(inventoryObjects.currencies.items.softMoney, item.sellPrice)
    end

    return {
        getCopy = getCopy,
        getCopyOfAllItems = getCopyOfAllItems,
        buy = buy,
        sell = sell
    }
end

shop = Shop()