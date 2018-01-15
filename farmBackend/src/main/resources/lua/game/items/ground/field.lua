function Field(initializer)
    initializer.type = 'factories'
    local it = Item(initializer)
    it.plant = {}
    it.currentState = "unplowed"
    local actionsByState = {
        unplowed = function(farm, worker, target)
            if worker.hand.id ~= 'shovel' then
                error("Field is waiting for shovel but got: " .. json.stringify(worker.hand))
            end
            local field = farm.cells[target.row][target.col]
            field.currentState = "plowed"
            return {farm = farm, worker = worker}
        end,
        plowed = function(farm, worker, target)
            if worker.hand.type ~= 'seeds' then
                error("Field is waiting for 'seeds' but got: " .. json.stringify(worker.hand))
            end
            local field = farm.cells[target.row][target.col]
            if field.plant.id then
                error("Already sowed with " .. json.stringify(field.plant))
            end
            field.plant = worker.hand
            field.endTime = os.time() * 1000 + field.plant.preparationTime
            field.currentState = "planted"
            worker.hand = {}
            return { farm = farm, worker = worker }
        end,
        planted = function(farm, worker, target)
            -- DELEGATE TO PLANT
            local field = farm.cells[target.row][target.col]
            local plant = factory.createPickable(pickableObjects[field.plant.type][field.plant.id])
            if not plant then
                error("Plant object is not present but field is in 'planted' state")
            end
            return plant.use(farm, worker, target)
        end
    }
    it.use = function(farm, worker, target)
        local field = farm.cells[target.row][target.col]
        if (type(actionsByState[field.currentState]) ~= "function") then
            error ("Field hasn't action for state: " .. json.stringify(field.currentState))
        end
        return actionsByState[field.currentState](farm, worker, target)
    end
    return it
end