--local createObject = function(type, id)
--    if type ==
--end

local createPickable = function(initializer)
    local category = pickableObjects[initializer.type]
    if not category then
        error("No pickable objects of type '" .. json.stringify(initializer.type) .. "' are present for initializer: "..json.stringify(initializer))
    end
    local item = category[initializer.id]
    if not item then
        error("No item of category '" .. json.stringify(initializer.type) .. "' with id '" .. json.stringify(initializer.id) .. "' is present")
    end
    if initializer.type == "seeds" then
        return Seed(initializer)
    end
    return Item(initializer)
end

local createGround = function(initializer)
    if not initializer or not initializer.id then
        error ("Failed to create ground with nil id or initializer. Initializer value: " .. json.stringify(initializer))
    end
    if initializer.type == "roads" then
        return Road(initializer)
    elseif initializer.type == "spawnBoxes" then
        return SpawnBox(initializer)
    elseif initializer.type == "factories" then
        --todo: generalize
        if initializer.id == "field" then
            return Field(initializer)
        elseif initializer.id == "caravanParkingPlace" then
            return CaravanParkingPlace(initializer)
        end
    end
    return Item(initializer)
end

factory = {
    createPickable = createPickable,
    createGround = createGround
}