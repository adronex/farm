local exportFarm = function(farmJsonObject)
    local farm = json.parse(farmJsonObject)
    farms[farm.name] = farm
end

--todo: this is an alpha-version implementation
local loadCurrentFarmData = function(exportData)
    if exportData and type(exportData) == "table" then
        local farm = exportData
        return farm
    end
    error("Can't export farm - export data is invalid: " .. json.stringify(exportData))
end

local loadFarmByName = function(name)
    if farms[name] ~= nil then
        farm = farms[name]
    else
        error("Can't load farm with name '" .. name .. "' because it doesn't exist")
    end
end

local applyWorkerToCell = function(farm, worker, target)
    if not worker or not worker.id then
        error("Invalid worker object: " .. json.stringify(worker))
    end
    if not target or not target.row or not target.col then
        error("Invalid target object: " .. json.stringify(target))
    end
    --todo: static data check/rework
    local cell = farm.cells[target.row][target.col]
    local initializers = groundObjects[cell.type]
    if not initializers then
        error("There is no initializers of type " .. cell.type)
    end
    local invokableInitializer = initializers[cell.id]
    local invokable = factory.createGround(invokableInitializer)
    local response = invokable.use(farm, worker, target)
    return { farm = response.farm, worker = response.worker }
end

farmService = {
    exportFarm = exportFarm,
    loadCurrentFarmData = loadCurrentFarmData,
    loadFarmByName = loadFarmByName,
    applyWorkerToCell = applyWorkerToCell
}

farms = {}