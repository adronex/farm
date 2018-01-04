function Bag(exportData)
    local bagItems
    if exportData and type(exportData) == "table" then
        bagItems = exportData
    else
        bagItems = {
            {
                id = inventoryObjects.currencies.items.softMoney,
                type = inventoryObjects.currencies.type,
                count = 20
            }
        }
    end

    local decreaseCount = function(itemId, count)
        local found = utils.findInArray(bagItems, function(it) return it.id == itemId end)
        if not found then
            error ("No item with id '"..itemId.."' have been found in inventory")
        end
        if found.count < count then
            error ("Not enough '"..itemId.."', need: "..count..", available: "..found.count)
        end
        found.count = found.count - count
    end

    local increaseCount = function(itemId, count)
        local bagItem = utils.findInArray(bagItems, function(it) return it.id == itemId end)
        bagItem.count = bagItem.count + count
    end

    local getCopyOfAllItems = function()
        return utils:copy(bagItems)
    end

    return {
        decreaseCount = decreaseCount,
        increaseCount = increaseCount,
        getCopyOfAllItems = getCopyOfAllItems
    }
end

bag = Bag()