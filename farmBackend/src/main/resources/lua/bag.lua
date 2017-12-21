function Bag(exportData)
    local bagItems
    if exportData and type(exportData) == "table" then
        bagItems = exportData
    else
        bagItems = {
            {
                item = staticData.getItems().softMoney,
                count = 20
            },
            {
                item = staticData.getItems().wheat,
                count = 2
            },
            {
                item = staticData.getItems().wateringCan,
                count = 1
            }
        }
    end

    local getOrCreate = function(itemId)
        local found = utils.findInArray(bagItems, function(it) return it.item.id == itemId end)

        if found then return found
        else found = staticData.getItems()[itemId]
        end

        if not found then
            error ("No item with id '"..itemId.."' have been found in application")
        end

        local newBagItem = {item = found, count = 0 }
        table.insert(bagItems, newBagItem)
        return newBagItem
    end

    local decreaseCount = function(itemId, count)
        local found = getOrCreate(itemId);
        if found.count < count then
            error ("Not enough '"..itemId.."', need: "..count..", available: "..found.count)
        end
        found.count = found.count - count;
    end

    local increaseCount = function(itemId, count)
        local bagItem = getOrCreate(itemId)
        bagItem.count = bagItem.count + count;
    end

    local getCopyOfAllItems = function()
        return utils:copy(bagItems)
    end

    return {
        getOrCreate = getOrCreate,
        decreaseCount = decreaseCount,
        increaseCount = increaseCount,
        getCopyOfAllItems = getCopyOfAllItems
    }
end

bag = Bag()