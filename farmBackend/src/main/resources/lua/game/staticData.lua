function StaticData()
    local itemTypes = {
        currency = "currency",
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

    items.softMoney = Item({
        id = "softMoney",
        type = itemTypes.currency
    })
    items.wateringCan = Item({
        id = "wateringCan",
        type = itemTypes.tool
    })
    items.basket = Item({
        id = "basket",
        type = itemTypes.tool
    })
    items.basket.objects = {}
    items.basketStand = Stand({
        id = "basketStand",
        type = itemTypes.stand,
        toolToHoldId = "basket"
    })
--    items.sickle = Item({
--        id = "sickle",
--        type = itemTypes.tool,
--        countable = false,
--        use = function(target)
--            if not target or target.id ~= items.field.id then
--                error("Can't apply 'sickle', invalid target: " .. target)
--            end
--            if #target.queue == 0 then
--                error("Production queue is empty")
--            end
--            if os.time() * 1000 < target.endTime then
--                error("Field is not ready yet. It will be ready after "..(target.endTime - os.time() * 1000).." milliseconds")
--            end
--            local reaped = table.remove(target.queue, 1)
--            target.endTime = nil
--            target.currentProductionTimeLeft = nil
--            bag.increaseCount(reaped.id, reaped.harvestValue)
--            return utils:copy(target)
--        end
--    });
--    items.wheat = Plant({
--        id = "wheat",
--        preparationTime = 10000,
--        harvestValue = 3
--    });
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
    items.ground = Item({
        id = "ground",
        type = itemTypes.foundation
    })
    items.road = Item({
        id = "road",
        type = itemTypes.road,
        use = function(worker, target)
            worker.position.row = target.row
            worker.position.col = target.col
        end
    })
    items.field = Field({
        id = "field"
    })
    items.well = Item({
        id = "well",
        type = itemTypes.foundation
    })
    items.carrotSpawnBox = Item({
        id = "carrotSpawnBox",
        type = itemTypes.spawnBox,
        buyPrice = 3,
        use = function(worker, target)
            if worker.hand.id then
                error ("Worker's hand must be empty, but it has "..worker.hand.id)
            end
            local carrot = staticData.getItems().carrotSeed;
            --todo: buyPrice
            bag.decreaseCount(staticData.getItems().softMoney.id, 3)
            worker.hand = carrot
        end
    })
    local caravanInitializer = {
        id = "caravan",
        orders = {
            {
                itemId = "carrot",
                countFrom = 3,
                countTo = 6
            }
        },
        rewards = {
            {
                itemId = "softMoney",
                count = 10
            }
        }
    }
    local caravanToBeRemoved = Caravan(caravanInitializer)
    items.caravanParkingPlace = Item({
        id = "caravanParkingPlace",
        type = itemTypes.caravanParkingPlace,
        use = function(worker, target)
            local parkingPlace = farm.getOriginalFarmCells()[target.row][target.col]
            if not parkingPlace.caravan then
                error ("Parking place is empty")
            end
            caravanToBeRemoved.use(worker, target)
            if caravanToBeRemoved.isReady(parkingPlace.caravan) then
                for _, reward in pairs(parkingPlace.caravan.rewards) do
                    bag.increaseCount(reward.itemId, reward.count)
                end
                parkingPlace.caravan = Caravan(caravanInitializer)
            end
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
