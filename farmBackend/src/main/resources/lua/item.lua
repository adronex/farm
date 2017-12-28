function Item(initializer)
    if not initializer.id or not initializer.type then
        error("Id and type parameters are mandatory")
    end
    local id = initializer.id
    local type = initializer.type
    local use = function(target)
        error("'use' function isn't implemented' for item " .. id .. " of type " .. type)
    end
    if initializer.use then
        use = initializer.use
    end
    local countable = true
    if initializer.countable ~= nil then
        countable = initializer.countable
    end

    return {
        id = id,
        type = type,
        use = use,
        countable = countable
    }
end

function Plant(initializer)
    initializer.type = 'plant'
    local it = Item(initializer)
    it.preparationTime = initializer.preparationTime;
    it.harvestValue = initializer.harvestValue;
    it.use = function(target)
        bag.decreaseCount(it.id, 1)
        if not target or target.type ~= "field" then
            error("Can't apply '" .. it.id .. "', invalid target: " .. target)
        end
        if #target.queue > 0 then
            error("Already sowed with " .. target.queue)
        end
        table.insert(target.queue, utils:copy(it))
        target.endTime = os.time() * 1000 + it.preparationTime
        return utils:copy(target)
    end
    return it
end

function Field(initializer)
    initializer.type = 'field'
    local it = Item(initializer)
    it.queue = {}
    it.use = function(target)
        bag.decreaseCount(it.id, 1)
        if not target or target.id ~= 'ground' then
            error("Can't apply '" .. it.id .. "', invalid target: " .. target)
        end
        return utils:copy(it)
    end
    return it
end