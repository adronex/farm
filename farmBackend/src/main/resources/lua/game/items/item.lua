function Item(initializer)
    if not initializer.id or not initializer.type then
        error("Id and type parameters are mandatory")
    end
    local id = initializer.id
    local type = initializer.type
    local use = function(worker, target)
        error("'use' function isn't implemented for item '" .. id .. "' of type '" .. type .."'")
    end
    if initializer.use then
        use = initializer.use
    end

    return {
        id = id,
        type = type,
        use = use
    }
end