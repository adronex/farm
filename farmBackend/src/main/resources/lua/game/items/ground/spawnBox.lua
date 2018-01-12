function SpawnBox(initializer)
    initializer.mandatoryFields = {"buyPrice", "spawnObjectId", "spawnObjectType"}
    initializer.type = groundObjects.spawnBoxes.type
    local it = Item(initializer)
    it.use = function(farm, worker, target)
        local box = farm.cells[target.row][target.col]
        --todo: addType
      --  local spawnedObject = factory[box.spawnObjectType][box.spawnObjectId]
        local spawnedObject = staticData.getItems()[box.spawnObjectId]
        --todo: bagService
        bag.decreaseCount(inventoryObjects.currencies.items.softMoney, box.buyPrice)
        worker.hand = spawnedObject
        return { farm = farm, worker = worker }
    end
    return it
end