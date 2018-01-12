function CaravanParkingPlace(initializer)
    initializer.type = groundObjects.factories.type
    local it = Item(initializer)
    it.caravan = {}
    it.currentState = "empty"
    local actionsByState = {
        empty = function(farm, worker, target)
            error ("Parking place is empty")
        end,
        busy = function(farm, worker, target)
            local caravanParkingPlace = farm.cells[target.row][target.col]
            local caravan = caravanParkingPlace.caravan
            if not caravan then
                error ("Caravan parking place is empty but it is in 'busy' state")
            end
            return caravan.use(farm, worker, target)
        end
    }
    it.use = function(farm, worker, target)
        local parkingPlace = farm.cells[target.row][target.col]
        if not parkingPlace.caravan then
        end
--        farm = caravanToBeRemoved.use(farm, worker, target).farm

        return { farm = farm, worker = worker }
    end
    return it
end