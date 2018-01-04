function Stand(initializer)
    initializer.type = 'stand'
    local it = Item(initializer)
    it.toolToHoldId = initializer.toolToHoldId
    it.currentToolId = initializer.toolToHoldId
    it.use = function(farm, worker, target)
        local stand = farm.cells[target.row][target.col]
        if worker.hand.id and not stand.currentToolId then
            if worker.hand.id ~= stand.toolToHoldId then
                error ("Stand can hold only "..stand.toolTypeTo..", but worker is trying to put "..json.stringify(worker.hand))
            end
            stand.toolToHoldId = worker.hand.id
            worker.hand = {}
        elseif not worker.hand.id and stand.currentToolId then
            local tool = {
                id = pickableObjects.tools.items[stand.currentToolId],
                type = pickableObjects.tools.type
            }
            worker.hand = tool
            stand.currentToolId = nil
        else
            error ("Worker hand shold be empty and stand should contain object. Actual state is: hand - "..json.stringify(worker.hand)..", stand - "..json.stringify(stand))
        end
        return { farm = farm, worker = worker }
    end
    return it
end