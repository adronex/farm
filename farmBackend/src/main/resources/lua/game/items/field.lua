function Field(initializer)
    initializer.type = 'field'
    local it = Item(initializer)
    it.plant = {}
    it.state = "unplowed"
    local actions = {
        unplowed = function(farm, worker, target)
            if worker.hand.id ~= 'shovel' then
                error("Field is waiting for shovel but got: " .. json.stringify(worker.hand))
            end
            local field = farm.cells[target.row][target.col]
            field.state = "plowed"
            return {farm = farm, worker = worker}
        end,
        plowed = function(farm, worker, target)
            if worker.hand.type ~= 'seed' then
                error("Field is waiting for seed but got: " .. json.stringify(worker.hand))
            end
            local field = farm.cells[target.row][target.col]
            if field.plant.id then
                error("Already sowed with " .. json.stringify(field.plant))
            end
            field.plant = worker.hand
            field.endTime = os.time() * 1000 + field.plant.preparationTime
            field.state = "planted"
            worker.hand = {}
            return { farm = farm, worker = worker }
        end,
        planted = function(farm, worker, target)
            local field = farm.cells[target.row][target.col]
            if os.time() * 1000 < field.endTime then
                error("Field is not ready yet. It will be ready after " .. (field.endTime - os.time() * 1000) .. " milliseconds")
            end
            if worker.hand.id ~= pickableObjects.tools.items.basket then
                error("Field is waiting for basket but got: " .. json.stringify(worker.hand))
            end
            local collected = field.plant
            field.endTime = nil
            field.plant = {}
            for i = 1, collected.fruitsCount, 1 do
                if not worker.hand.objects then
                    worker.hand.objects = {}
                end
                table.insert(worker.hand.objects, staticData.getItems()[collected.fruitId])
            end
            field.state = "unplowed"
            return { farm = farm, worker = worker }
        end
    }
    it.use = function(farm, worker, target)
        local field = farm.cells[target.row][target.col]
        if (type(actions[field.state]) ~= "function") then
            error ("There is no action for state: " .. it.state)
        end
        return actions[field.state](farm, worker, target)
    end
    return it
end