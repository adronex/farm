-- todo: spawnBox?? spawnObjectToObject??
function Seed(initializer)
    initializer.mandatoryFields = {"preparationTime", "fruitsCount", "fruitId"}
    initializer.type = 'seeds'
    local it = Item(initializer)
    it.currentState = "readyForCollection"

    local actionsByState = {
        readyForCollection = function(farm, worker, target)
            local field = farm.cells[target.row][target.col]
            if os.time() * 1000 < field.endTime then
                error("Plant is not ready yet. It will be ready after " .. (field.endTime - os.time() * 1000) .. " milliseconds")
            end
            if worker.hand.id ~= pickableObjects.tools.basket.id then
                error("Plant is waiting for basket but got: " .. json.stringify(worker.hand))
            end
            local collected = field.plant
            field.endTime = nil
            field.plant = {}
            for i = 1, collected.fruitsCount, 1 do
                if not worker.hand.objects then
                    worker.hand.objects = {}
                end
                local fruitInitializer = pickableObjects["fruits"][collected.fruitId]
                table.insert(worker.hand.objects, factory.createPickable(fruitInitializer))
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