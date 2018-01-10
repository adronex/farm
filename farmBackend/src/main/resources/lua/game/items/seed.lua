function Seed(initializer)
    initializer.type = 'seed'
    local it = Item(initializer)
    it.preparationTime = initializer.preparationTime;
    it.fruitsCount = initializer.fruitsCount;
    it.fruitId = initializer.fruitId;
    it.currentState = "readyForCollection"

    local actionsByState = {
        readyForCollection = function(farm, worker, target)
            local field = farm.cells[target.row][target.col]
            if os.time() * 1000 < field.endTime then
                error("Plant is not ready yet. It will be ready after " .. (field.endTime - os.time() * 1000) .. " milliseconds")
            end
            if worker.hand.id ~= pickableObjects.tools.items.basket then
                error("Plant is waiting for basket but got: " .. json.stringify(worker.hand))
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
            field.currentState = "unplowed"
            return { farm = farm, worker = worker }
        end
    }

    it.use = function(farm, worker, target)
        local plant = farm.cells[target.row][target.col].plant
        if (type(actionsByState[plant.currentState]) ~= "function") then
            error ("Plant hasn't action for state: " .. it.currentState)
        end
        return actionsByState[plant.currentState](farm, worker, target)
    end
    return it
end