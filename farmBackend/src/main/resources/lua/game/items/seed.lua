function Seed(initializer)
    initializer.type = 'seed'
    local it = Item(initializer)
    it.preparationTime = initializer.preparationTime;
    it.fruitsCount = initializer.fruitsCount;
    it.fruitId = initializer.fruitId;
    return it
end