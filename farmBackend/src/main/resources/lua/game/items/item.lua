inventoryObjects = {
    currencies = {
        type = "currencies",
        items = {
            softMoney = "softMoney"
        }
    }
}

pickableObjects = {
    tools = {
        type = "tools",
        items = {
            wateringCan = "wateringCan",
            shovel = "shovel",
            basket = "basket"
        }
    },
    seeds = {
        type = "seeds",
        items = {
            carrot = "carrot",
            wheat = "wheat",
            cucumber = "cucumber",
            corn = "corn"
        }
    },
    fruits = {
        type = "fruits",
        items = {
            carrot = "carrot",
            wheat = "wheat",
            cucumber = "cucumber",
            corn = "corn"
        }
    }
}

groundObjects = {
    foundations = {
        type = "foundations",
        items = {
            ground = "ground"
        }
    },
    fields = {
        type = "fields",
        item = {
            field = "field"
        }
    },
    stands = {
        type = "stands",
        items = {
            basketStand = "basketStand"
        }
    },
    factories = {
        type = "factories",
        items = {
            well = "well",
            caravanParkingPlace = "caravanParkingPlace"
        }
    },
    spawnBoxes = {
        type = "spawnBoxes",
        items = {
            carrot = "carrot",
            wheat = "wheat",
            cucumber = "cucumber",
            corn = "corn"
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
            error("Can't create item, field '" .. it .. "' is mandatory but is not set in initializer:" .. json.stringify(initializer))
        else
            self[it] = initializer[it]
        end
    end

    return self
end