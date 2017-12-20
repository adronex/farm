function StaticData()
    local itemTypes = {
        currency = "currency",
        foundation = "foundation",
        building = "building",
        tool = "tool",
        seed = "seed"
    }

    local items = {
        softMoney = Item({
            id = "softMoney",
            type = itemTypes.currency
        }),
        wateringCan = Item({
            id = "wateringCan",
            type = itemTypes.tool,
            uncountable = true
        }),
        sickle = Item({
            id = "sickle",
            type = itemTypes.tool,
            uncountable = true,
            use = function(target)
                if not target or target.id ~= items.field.id then
                    error("Can't apply 'sickle', invalid target: " .. target)
                end
                if #target.queue == 0 then
                    error("Production queue is empty")
                end
                if os.time() * 1000 < target.endTime then
                    error("Field is not ready yet. It will be ready after "..(target.endTime - os.time() * 1000).." milliseconds")
                end
                local reaped = table.remove(target.queue, 1)
                target.endTime = nil
                target.currentProductionTimeLeft = nil
                bag.increaseCount(reaped.id, reaped.harvestValue)
                return utils.copy(target)
            end
        }),
        wheat = Plant({
            id = "wheat",
            preparationTime = 10000,
            harvestValue = 3
        }),
        carrot = Plant({
            id = "carrot",
            preparationTime = 50000,
            harvestValue = 3
        }),
        ground = Item({
            id = "ground",
            type = itemTypes.foundation
        }),
        field = Field({}),
        well = Item({
            id = "well",
            type = itemTypes.foundation
        })
    }

    local getItemTypes = function()
        return utils.copy(itemTypes)
    end

    local getItems = function()
        return utils.copy(items)
    end

    return {
        getItemTypes = getItemTypes,
        getItems = getItems
    }
end

staticData = StaticData()
