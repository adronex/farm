-- todo: spawnBox?
function Stand(initializer)
    initializer.mandatoryFields = {"spawnObjectId", "spawnObject"}
    initializer.type = 'stand'
    local it = Item(initializer)
    it.use = function(farm, worker, target)
        local stand = farm.cells[target.row][target.col]
        worker.hand = pickableObjects["tools"][stand.toolToHoldId]
        return { farm = farm, worker = worker }
    end
    return it
end