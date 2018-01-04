local createFarm = function()
    local height = 7
    local width = 5
    local cells = {}

    for row = 1, height, 1 do
        cells[row] = {}
        for col = 1, width, 1 do
            cells[row][col] = {
                id = groundObjects.foundations.items.ground,
                type = groundObjects.foundations.type
            }
        end
    end
    --todo: static data rework
    cells[1][3] = staticData.getItems().carrotSpawnBox
    cells[2][3] = staticData.getItems().road
    cells[2][4] = staticData.getItems().caravanParkingPlace
    cells[3][3] = staticData.getItems().road
    cells[4][3] = staticData.getItems().road
    cells[5][3] = staticData.getItems().road
    cells[6][3] = staticData.getItems().road
    cells[7][3] = staticData.getItems().road
    cells[2][2] = staticData.getItems().field
    cells[3][2] = staticData.getItems().field
    cells[4][2] = staticData.getItems().field
    cells[5][2] = staticData.getItems().field
    cells[5][4] = staticData.getItems().basketStand

    return {
        width = width,
        height = height,
        cells = cells
    }
end

--todo: this is an alpha-version implementation
local exportFarm = function(exportData)
    if exportData and type(exportData) == "table" then
        local farm = createFarm()
        farm.cells = exportData
        return farm
    end
    error("Can't export farm - export data is invalid: " .. json.stringify(exportData))
end

local applyWorkerToCell = function(farm, worker, target)
    if not worker or not worker.id then
        error("Invalid worker object: " .. json.stringify(worker))
    end
    if not target or not target.row or not target.col then
        error("Invalid target object: " .. json.stringify(target))
    end
    --todo: static data check/rework
    local invokable = staticData.getItems()[farm.cells[target.row][target.col].id]
    local response = invokable.use(farm, worker, target)
    return { farm = response.farm, worker = response.worker }
end

farmService = {}
farmService.createFarm = createFarm
farmService.exportFarm = exportFarm
farmService.applyWorkerToCell = applyWorkerToCell

farm = createFarm()