function Item(initializer) {
    if (!initializer.id || !initializer.type) {
        throw 'Id and type parameters are mandatory'
    }
    this.id = initializer.id;
    this.type = initializer.type;
    this.use = function (target) {
        throw "'use' function isn't implemented' for item " + this.id + " of type " + this.type;
    };
    if (initializer.use !== undefined) {
        this.use = initializer.use;
    }
    if (initializer.countable !== undefined) {
        this.countable = true;
    }
}

function Plant(initializer) {
    initializer.type = 'plant';
    var it = new Item(initializer);
    it.constructor = arguments.callee;
    it.preparationTime = initializer.preparationTime;
    it.harvestValue = initializer.harvestValue;
    it.use = function (target) {
        if (!target || target.type !== "field") { //todo: ids to enum
            var targetString = target ? JSON.stringify(target) : undefined;
            throw "Can't apply '" + it.id + "', invalid target: " + targetString;
        }
        if (target.queue.length > 0) {
            throw "Already sowed with " + JSON.stringify(target.queue);
        }
        target.queue.push(utils.copy(it));
        target.endTime = new Date().getTime() + it.preparationTime;
        return utils.copy(target);
    };
    return it;
}

function Field(initializer) {
    initializer.type = 'field';
    var it = new Item(initializer);
    it.constructor = arguments.callee;
    it.queue = [];
    it.use = function (target) {
        // todo: ids to static data
        if (!target || target.id !== 'ground') {
            var targetString = target ? JSON.stringify(target) : undefined;
            throw "Can't apply 'field', invalid target: " + targetString;
        }
        return utils.copy(it);
    };
    return it;
}