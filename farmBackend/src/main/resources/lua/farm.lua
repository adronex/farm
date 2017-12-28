function Farm(exportData)
    local width = 5;
    local height = 7;
    local farm;

    if exportData and type(exportData) == "table" then
        farm = exportData
    else
        farm = {}
        for x = 1, height, 1 do
            farm[x] = {}
            for y = 1, width, 1 do
                farm[x][y] = staticData.getItems().ground
            end
        end
        farm[1][3] = staticData.getItems().carrotSpawnBox;
        farm[2][3] = staticData.getItems().road;
        farm[3][3] = staticData.getItems().road;
        farm[4][3] = staticData.getItems().road;
        farm[5][3] = staticData.getItems().road;
        farm[6][3] = staticData.getItems().road;
        farm[7][3] = staticData.getItems().road;
        farm[2][2] = staticData.getItems().field;
        farm[3][2] = staticData.getItems().field;
        farm[4][2] = staticData.getItems().field;
        farm[5][2] = staticData.getItems().field;
        farm[5][4] = staticData.getItems().well;
    end

    local applyHandToCell = function(hand, target, worker)
        if not hand or not hand.id then
            error("Invalid object in hand: " .. json.stringify(hand))
        end
        if not target or not target.x or not target.y then
            error("Invalid target object: " .. json.stringify(target))
        end
        local item = staticData.getItems()[hand.id]
        farm[target.x][target.y] = item.use(farm[target.x][target.y])
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
        width = width,
        height = height,
        applyHandToCell = applyHandToCell,
        getOriginalFarmObject = getOriginalFarmObject
    }
end