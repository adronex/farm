function Field(initializer)
    initializer.type = 'field'
    local it = Item(initializer)
   -- it.queue = {}
    it.plant = {}
    local sow = function(worker, target)
        local field = farm.cells[target.row][target.col]
        if field.plant.id then
            error("Already sowed with " .. json.stringify(field.plant))
        end
        field.plant = utils:copy(worker.hand)
        field.endTime = os.time() * 1000 + field.plant.preparationTime
        worker.hand = {}
    end
    local collect = function(worker, target)
        local field = farm.cells[target.row][target.col]
        if not field.plant then
            error("Field is not sowed")
        end
        if os.time() * 1000 < field.endTime then
            error("Field is not ready yet. It will be ready after "..(field.endTime - os.time() * 1000).." milliseconds")
        end
        local collected = field.plant
        field.endTime = nil
        field.currentProductionTimeLeft = nil
        field.plant = {}
        for i = 1, collected.fruitsCount, 1 do
            if not worker.hand.objects then
                worker.hand.objects = {}
            end
            table.insert(worker.hand.objects, staticData.getItems()[collected.fruitId])
        end
    end
    it.use = function(farm, worker, target)
        if worker.hand.type == 'seed' then
            --todo: rework from global to functional style
            sow(worker, target)
        elseif worker.hand.id == pickableObjects.tools.items.basket then
            --todo: rework from global to functional style
            collect(worker, target)
        else
            error ("Cant apply this hand to field: "..json.stringify(worker.hand))
        end
        return { farm = farm, worker = worker }
    end
    return it
end