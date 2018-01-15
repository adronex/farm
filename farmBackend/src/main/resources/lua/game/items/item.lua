inventoryObjects = {
    currencies = {
        softMoney = {
            id = "softMoney"
        }
    }
}

pickableObjects = {
    tools = {
--        type = "tools",
--        items = {
--            wateringCan = "wateringCan",
--            shovel = "shovel",
--            basket = "basket"
--        },
        wateringCan = {
            id = "wateringCan",
            type = "tools"
        },
        shovel = {
            id = "shovel",
            type = "tools"
        },
        basket = {
            id = "basket",
            type = "tools"
        }
    },
    seeds = {
--        type = "seeds",
--        items = {
--            carrot = "carrot",
--            wheat = "wheat",
--            cucumber = "cucumber",
--            corn = "corn"
--        },
        wheatSeed = {
            id = "wheatSeed",
            type = "seeds",
            preparationTime = 10000,
            fruitsCount = 5,
            fruitId = "wheat"
        },
        cucumberSeed = {
            id = "cucumberSeed",
            type = "seeds",
            preparationTime = 14000,
            fruitsCount = 4,
            fruitId = "wheat"
        },
        cornSeed = {
            id = "cornSeed",
            type = "seeds",
            preparationTime = 16000,
            fruitsCount = 4,
            fruitId = "wheat"
        }
    },
    fruits = {
--        type = "fruits",
--        items = {
--            carrot = "carrot",
--            wheat = "wheat",
--            cucumber = "cucumber",
--            corn = "corn"
--        },
        wheat = {
            id = "wheat",
            type = "fruits"
        },
        cucumber = {
            id = "cucumber",
            type = "fruits"
        },
        corn = {
            id = "corn",
            type = "fruits"
        },
    }
}

groundObjects = {
    foundations = {
        type = "foundations",
        items = {
            ground = "ground"
        }
    },
    factories = {
        field = {
            id = "field",
            type = "factories"
        },
        well = {
            id = "well",
            type = "factories"
        },
        caravanParkingPlace = {
            id = "caravanParkingPlace",
            type = "factories"
        }
    },
    roads = {
        road = {
            id = "road",
            type = "roads"
        }
    },
    spawnBoxes = {
--        type = "spawnBoxes",
--        items = {
--            carrot = "carrot",
--            wheat = "wheat",
--            cucumber = "cucumber",
--            corn = "corn"
--        },
        ----- SEEDS
        wheatSpawnBox = {
            id = "wheatSpawnBox",
            type = "spawnBoxes",
            spawnObjectId = "wheatSeed",
            spawnObjectType = "seed",
            buyPrice = 3
        },
        cornSpawnBox = {
            id = "cornSpawnBox",
            type = "spawnBoxes",
            spawnObjectId = "wheatSeed",
            spawnObjectType = "seed",
            buyPrice = 4
        },
        cucumberSpawnBox = {
            id = "cucumberSpawnBox",
            type = "spawnBoxes",
            spawnObjectId = "wheatSeed",
            spawnObjectType = "seed",
            buyPrice = 5
        },
        ----- TOOLS
        basketStand = {
            id = "basketStand",
            type = "spawnBoxes",
            spawnObjectId = "basket",
            spawnObjectType = "tools",
            buyPrice = 0
        },
        shovelStand = {
            id = "shovelStand",
            type = "spawnBoxes",
            spawnObjectId = "shovel",
            spawnObjectType = "tools",
            buyPrice = 0
        },
        wateringCanStand = {
            id = "wateringCanStand",
            type = "spawnBoxes",
            spawnObjectId = "wateringCan",
            spawnObjectType = "tools",
            buyPrice = 0
        }
    }
}

function Item(initializer)
    if not initializer.mandatoryFields or type(initializer.mandatoryFields) ~= "table" then
        initializer.mandatoryFields = {}
    end
    table.insert(initializer.mandatoryFields, "id")
    table.insert(initializer.mandatoryFields, "type")
    local self = {}
    self.use = function(farm, worker, target)
        error("'use' function hasn't been implemented for item '" .. self.id .. "' of type '" .. self.type .. "'")
    end
    for _, it in pairs(initializer.mandatoryFields) do
        if type(it) ~= "string" then
            error("Mandatory field should be string but it is a '" .. type(it) .. "'")
        elseif not (initializer[it]) then
            error("Can't create item, field '" .. it .. "' is mandatory but is not set in initializer: " .. json.stringify(initializer))
        else
            self[it] = initializer[it]
        end
    end

    return self
end