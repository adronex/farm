inventoryObjects = {
    currencies = {
        type = "currency",
        items = {
            softMoney = "softMoney"
        }
    }
}

pickableObjects = {
    tools = {
        type = "tool",
        items = {
            wateringCan = "wateringCan",
            shovel = "shovel",
            basket = "basket"
        }
    },
    seeds = {
        type = "seed",
        items = {
            carrot = "carrot"
        }
    },
    fruits = {
        type = "fruit",
        items = {
            carrot = "carrot"
        }
    }
}

groundObjects = {
    foundations = {
        type = "foundation",
        items = {
            ground = "ground"
        }
    },
    fields = {
        type = "field",
        item = {
            field = "field"
        }
    },
    stands = {
        type = "stand",
        items = {
            basketStand = "basketStand"
        }
    }
}

function Item(initializer)
    if not initializer.id or not initializer.type then
        error("Id and type parameters are mandatory")
    end
    local id = initializer.id
    local type = initializer.type
    local use = function(farm, worker, target)
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