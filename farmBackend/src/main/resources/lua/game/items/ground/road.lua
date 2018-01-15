function Road(initializer)
    initializer.type = "roads"
    local it = Item(initializer)
    it.use = function(farm, worker, target)
        worker.position.row = target.row
        worker.position.col = target.col
        return { farm = farm, worker = worker }
    end
    return it
end