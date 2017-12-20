function Farm(exportData)
    local FIELD_HEIGHT = 10;
    local FIELD_WIDTH = 10;
    local farm;

    if exportData and type(exportData) == "table" then
        farm = exportData
    else
        farm = {}
        for i = 0, FIELD_HEIGHT - 1, 1 do
            farm[i] = {}
            for j = 0, FIELD_WIDTH - 1, 1 do
                farm[i][j] = staticData.getItems().ground
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
        if bag.getOrCreate(hand.id).count <= 0 then
            error("Not enough '" .. hand.id .. "'. Target: " .. target .. ". Cell: " .. farm[target.x][target.y])
        end
        local item = staticData.getItems()[hand.id]
        farm[target.x][target.y] = item.use(farm[target.x][target.y])
        bag.decreaseCount(hand.id, 1)
    end

    local updateTimerDeltas = function()
        for x = 0, #farm - 1, 1 do
            for y = 0, #farm[x] - 1, 1 do
                if farm[x][y] then
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