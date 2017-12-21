function Farm(exportData)
    local FIELD_HEIGHT = 10;
    local FIELD_WIDTH = 10;
    local farm;

    if exportData and type(exportData) == "table" then
        farm = exportData
    else
        farm = {}
        for x = 1, FIELD_HEIGHT, 1 do
            farm[x] = {}
            for y = 1, FIELD_WIDTH, 1 do
                farm[x][y] = staticData.getItems().ground
            end
        end
    end

    local applyHandToCell = function(hand, target)
        if not hand or not hand.id then
            error("Invalid object in hand: " .. hand)
        end
        if not target or not target.x or not target.y then
            error("Invalid target object: " .. target)
        end
        target.x = target.x + 1 -- lua arrays start from 1
        target.y = target.y + 1 -- lua arrays start from 1
        if bag.getOrCreate(hand.id).count <= 0 then
            error("Not enough '" .. hand.id .. "'. Target: " .. json.stringify(target) .. ". Cell: " .. json.stringify(farm[target.x][target.y]))
        end
        local item = staticData.getItems()[hand.id]
        farm[target.x][target.y] = item.use(farm[target.x][target.y])
        bag.decreaseCount(hand.id, 1)
    end

    local updateTimerDeltas = function()
        for x = 1, #farm, 1 do
            for y = 1, #farm[x], 1 do
                if farm[x][y] and farm[x][y].endTime then
                    local delta = farm[x][y].endTime - os.time() * 1000
                    if delta > 0 then
                        farm[x][y].currentProductionTimeLeft = delta
                    else
                        farm[x][y].currentProductionTimeLeft = 0;
                    end
                end
            end
        end
    end

    local getOriginalFarmObject = function()
        updateTimerDeltas()
        return farm
    end

    return {
        applyHandToCell = applyHandToCell,
        getOriginalFarmObject = getOriginalFarmObject
    }
end