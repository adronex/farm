function Stand(initializer)
    initializer.mandatoryFields = {"toolToHoldId"}
    initializer.type = 'stand'
    local it = Item(initializer)
    it.use = function(farm, worker, target)
        local stand = farm.cells[target.row][target.col]
        local tool = {
            id = pickableObjects.tools.items[stand.toolToHoldId],
            type = pickableObjects.tools.type
        }
        worker.hand = tool
        return { farm = farm, worker = worker }
    end
    return it
end