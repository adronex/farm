local createWorker = function()
    local id = "Uasya"
    local hand = {}
    local position = {
        row = 2,
        col = 3
    }

    return {
        id = id,
        hand = hand,
        position = position
    }
end

local assignWorker = function(worker, farm, position)
    if position.row < 1 or position.row > farm.height
            or position.col < 1 or position.col > farm.width then
        error("Trying to assing worker out of farm bounds, position: " .. json.stringify(position))
    end
    --todo: static data check/rework
    if farm[position.row][position.col].type ~= staticData.getItems().road then
        error("Target is not the road but " .. farm[position.row][position.col].type)
    end
    worker.position = position
    return { worker = worker }
end

local moveWorker = function (worker, farm, direction)

    local newRow = worker.position.row
    local newCol = worker.position.col

    if direction == "UP" then
        newRow = newRow - 1
    elseif direction == "DOWN" then
        newRow = newRow + 1
    elseif direction == "LEFT" then
        newCol = newCol - 1
    elseif direction == "RIGHT" then
        newCol = newCol + 1
    else
        error("Unknown direction: " .. direction);
    end

    if newRow < 1 or newRow > farm.height
            or newCol < 1 or newCol > farm.width then
        error("Trying to move out of farm bounds, row: " .. newRow .. ", col: " .. newCol)
    end

    local response = farmService.applyWorkerToCell(farm, worker, {row = newRow, col = newCol})

    return { farm = response.farm, worker = response.worker }
end

workerService = {}
workerService.createWorker = createWorker
workerService.moveWorker = moveWorker

workers = { createWorker() }