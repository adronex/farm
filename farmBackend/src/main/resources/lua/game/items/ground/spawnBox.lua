function SpawnBox(initializer)
    initializer.mandatoryFields = {"spawnObjectId", "spawnObjectType", "buyPrice"}
    initializer.type = "spawnBoxes"
    local it = Item(initializer)
    it.use = function(farm, worker, target)
        local box = farm.cells[target.row][target.col]
        local spawnObjectCategory = pickableObjects[box.spawnObjectType]
        if not spawnObjectCategory then
            error ("Invalid spawn object type '" .. json.stringify(box.spawnObjectType) .. "' for spawn box: " .. json.stringify(box))
        end
        local spawnedObjectInitializer = spawnObjectCategory[box.spawnObjectId]
        local spawnedObject = factory.createPickable(spawnedObjectInitializer)
        --todo: bagService
        if box.buyPrice and box.buyPrice > 0 then
            bag.decreaseCount(inventoryObjects.currencies.softMoney.id, box.buyPrice)
        end
        worker.hand = spawnedObject
        return { farm = farm, worker = worker }
    end
    return it
end