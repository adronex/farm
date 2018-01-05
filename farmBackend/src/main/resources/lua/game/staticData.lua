function StaticData()
    local itemTypes = {
        foundation = "foundation",
        caravanParkingPlace = "caravanParkingPlace",
        road = "road",
        spawnBox = "spawnBox",
        building = "building",
        tool = "tool",
        stand = "stand",
        seed = "seed",
        fruit = "fruit"
    }

    local items = {}

    items.basketStand = Stand({
        id = "basketStand",
        type = itemTypes.stand,
        toolToHoldId = "basket"
    })
    items.shovelStand = Stand({
        id = "shovelStand",
        type = itemTypes.stand,
        toolToHoldId = "shovel"
    })
    items.carrot = Item({
        id = "carrot",
        type = itemTypes.fruit
    })
    items.carrotSeed = Seed({
        id = "carrotSeed",
        preparationTime = 10000,
        fruitsCount = 3,
        fruitId = "carrot"
    })
    items.road = Item({
        id = "road",
        type = itemTypes.road,
        use = function(farm, worker, target)
            worker.position.row = target.row
            worker.position.col = target.col
            return { farm = farm, worker = worker }
        end
    })
    items.field = Field({
        id = "field"
    })
    items.carrotSpawnBox = Item({
        id = "carrotSpawnBox",
        type = itemTypes.spawnBox,
        use = function(farm, worker, target)
            local carrot = staticData.getItems().carrotSeed;
            --todo: buyPrice
            --todo: bagService
            bag.decreaseCount(inventoryObjects.currencies.items.softMoney, 3)
            worker.hand = carrot
            return { farm = farm, worker = worker }
        end
    })
    items.carrotSpawnBox.spawnObjectId = pickableObjects.seeds.items.carrot;
    items.carrotSpawnBox.buyPrice = 3;
    local caravanInitializer = {
        id = "caravan",
        orders = {
            {
                itemId = "carrot",
                countFrom = 6,
                countTo = 10
            }
        },
        rewards = {
            {
                itemId = inventoryObjects.currencies.items.softMoney,
                count = 10
            }
        }
    }
    local caravanToBeRemoved = Caravan(caravanInitializer)
    items.caravanParkingPlace = Item({
        id = "caravanParkingPlace",
        type = itemTypes.caravanParkingPlace,
        use = function(farm, worker, target)
            local parkingPlace = farm.cells[target.row][target.col]
            if not parkingPlace.caravan then
                error ("Parking place is empty")
            end
            farm = caravanToBeRemoved.use(farm, worker, target).farm
            if caravanToBeRemoved.isReady(parkingPlace.caravan) then
                for _, reward in pairs(parkingPlace.caravan.rewards) do
                    bag.increaseCount(reward.itemId, reward.count)
                end
                parkingPlace.caravan = Caravan(caravanInitializer)
            end
            return { farm = farm, worker = worker }
        end
    })
    items.caravanParkingPlace.caravan = Caravan(caravanInitializer)

    local getItemTypes = function()
        return utils:copy(itemTypes)
    end

    local getItems = function()
        return utils:copy(items)
    end

    return {
        getItemTypes = getItemTypes,
        getItems = getItems
    }
end

staticData = StaticData()
