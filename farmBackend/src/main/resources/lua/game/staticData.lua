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
    items.wateringCanStand = Stand({
        id = "wateringCanStand",
        type = itemTypes.stand,
        toolToHoldId = "wateringCan"
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
    items.wheat = Item({
        id = "wheat",
        type = itemTypes.fruit
    })
    items.wheatSeed = Seed({
        id = "wheatSeed",
        preparationTime = 3000,
        fruitsCount = 5,
        fruitId = "wheat"
    })
    items.cucumber = Item({
        id = "cucumber",
        type = itemTypes.fruit
    })
    items.cucumberSeed = Seed({
        id = "cucumberSeed",
        preparationTime = 14000,
        fruitsCount = 4,
        fruitId = "cucumber"
    })
    items.corn = Item({
        id = "corn",
        type = itemTypes.fruit
    })
    items.cornSeed = Seed({
        id = "cornSeed",
        preparationTime = 16000,
        fruitsCount = 4,
        fruitId = "corn"
    })
    items.road = Road({
        id = "road"
    })
    items.wateringCan = Item({
        id = pickableObjects.tools.items.wateringCan,
        type = pickableObjects.tools.type,
--        use = function(farm, worker, target)
--            worker.position.row = target.row
--            worker.position.col = target.col
--            return { farm = farm, worker = worker }
--        end
    })
    items.field = Field({
        id = "field"
    })
    items.carrotSpawnBox = SpawnBox({
        id = "carrotSpawnBox",
        spawnObjectId = pickableObjects.seeds.items.carrot,
        spawnObjectType = pickableObjects.seeds.type,
        buyPrice = 3
    })
    items.wheatSpawnBox = SpawnBox({
        id = "wheatSpawnBox",
        spawnObjectId = pickableObjects.seeds.items.wheat,
        spawnObjectType = pickableObjects.seeds.type,
        buyPrice = 3
    })
    items.cornSpawnBox = SpawnBox({
        id = "cornSpawnBox",
        spawnObjectId = pickableObjects.seeds.items.corn,
        spawnObjectType = pickableObjects.seeds.type,
        buyPrice = 4
    })
    items.cucumberSpawnBox = SpawnBox({
        id = "cucumberSpawnBox",
        spawnObjectId = pickableObjects.seeds.items.cucumber,
        spawnObjectType = pickableObjects.seeds.type,
        buyPrice = 5
    })
    local caravanInitializer = {
        id = "caravan",
        orders = {
            {
                itemId = pickableObjects.fruits.items.carrot,
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
  --  local caravanToBeRemoved = Caravan(caravanInitializer)
    items.caravanParkingPlace = CaravanParkingPlace({
        id = "caravanParkingPlace"
    })
    items.defaultCaravan = Caravan(caravanInitializer)

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
