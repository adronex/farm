function Field(initializer)
    initializer.mandatoryFields = {"states", "currentState"}
    initializer.type = 'factories'
    local it = Item(initializer)
    it.plant = {}
    it.getNextState = function(field)
        field.currentState = (field.currentState % #field.states) + 1
        return field
    end
    if initializer.readyTime then
        it.readyTime = initializer.readyTime
    end
    if initializer.plant then
        it.plant = initializer.plant
    end
    local actionsByState = {
        unplowed = function(farm, worker, target)
            if worker.hand.id ~= 'shovel' then
                error("Field is waiting for shovel but got: " .. json.stringify(worker.hand))
            end
            local fieldInitializer = farm.cells[target.row][target.col]
            local field = factory.createGround(fieldInitializer)
            field.readyTime = os.time() * 1000 + 1000
            farm.cells[target.row][target.col] = field.getNextState(field)
            return {farm = farm, worker = worker}
        end,
        plowed = function(farm, worker, target)
            if worker.hand.type ~= 'seeds' then
                error("Field is waiting for 'seeds' but got: " .. json.stringify(worker.hand))
            end
            local fieldInitializer = farm.cells[target.row][target.col]
            local field = factory.createGround(fieldInitializer)
            if field.plant.id then
                error("Already sowed with " .. json.stringify(field.plant))
            end
            field.plant = worker.hand
            field.readyTime = os.time() * 1000 + field.plant.readyTime
            farm.cells[target.row][target.col] = field.getNextState(field)
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
        local state = field.states[field.currentState]
        if (type(actionsByState[state]) ~= "function") then
            error ("Field hasn't action for state: " .. json.stringify(state))
        end
        return actionsByState[state](farm, worker, target)
    end
    return it
end