function Farm(exportData)
    local width = 5;
    local height = 7;
    local farmCells;

    if exportData and type(exportData) == "table" then
        farmCells = exportData
    else
        farmCells = {}
        for row = 1, height, 1 do
            farmCells[row] = {}
            for col = 1, width, 1 do
                farmCells[row][col] = staticData.getItems().ground
            end
        end
        farmCells[1][3] = staticData.getItems().carrotSpawnBox;
        farmCells[2][3] = staticData.getItems().road;
        farmCells[3][3] = staticData.getItems().road;
        farmCells[4][3] = staticData.getItems().road;
        farmCells[5][3] = staticData.getItems().road;
        farmCells[6][3] = staticData.getItems().road;
        farmCells[7][3] = staticData.getItems().road;
        farmCells[2][2] = staticData.getItems().field;
        farmCells[3][2] = staticData.getItems().field;
        farmCells[4][2] = staticData.getItems().field;
        farmCells[5][2] = staticData.getItems().field;
        farmCells[5][4] = staticData.getItems().basketStand;
        farmCells[5][5] = staticData.getItems().well;
    end

    --DEPRECATED
    local applyHandToCell = function(hand, target)
        if not hand or not hand.id then
            error("Invalid object in hand: " .. json.stringify(hand))
        end
        if not target or not target.row or not target.col then
            error("Invalid target object: " .. json.stringify(target))
        end
        local item = staticData.getItems()[hand.id]
        farmCells[target.row][target.col] = item.use(farmCells[target.row][target.col])
    end

    local applyWorkerToCell = function(worker, target)
        if not worker or not worker.id then
            error("Invalid worker object: " .. json.stringify(hand))
        end
        if not target or not target.row or not target.col then
            error("Invalid target object: " .. json.stringify(target))
        end
        local invokable = staticData.getItems()[farmCells[target.row][target.col].id]
        invokable.use(worker, target)
    end

    local updateTimerDeltas = function()
        for row = 1, #farmCells, 1 do
            for col = 1, #farmCells[row], 1 do
                if farmCells[row][col] and farmCells[row][col].endTime then
                    local delta = farmCells[row][col].endTime - os.time() * 1000
                    if delta > 0 then
                        farmCells[row][col].currentProductionTimeLeft = delta
                    else
                        farmCells[row][col].currentProductionTimeLeft = 0;
                    end
                end
            end
        end
    end

    local getOriginalFarmCells = function()
        updateTimerDeltas()
        return farmCells
    end

    return {
        width = width,
        height = height,
        applyHandToCell = applyHandToCell,
        applyWorkerToCell = applyWorkerToCell,
        getOriginalFarmCells = getOriginalFarmCells
    }
end