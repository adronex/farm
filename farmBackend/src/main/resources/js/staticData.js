function StaticData() {
    var itemTypes = {
        currency: "currency",
        foundation: "foundation",
        building: "building",
        tool: "tool",
        seed: "seed"
    };

    var items = {
        softMoney: new Item({
            id: "softMoney",
            type: itemTypes.currency
        }),
        wateringCan: new Item({
            id: "wateringCan",
            type: itemTypes.tool,
            uncountable: true
        }),
        sickle: new Item({
            id: "sickle",
            type: itemTypes.tool,
            uncountable: true,
            use: function (target) {
                if (!target || target.id !== items.field.id) {
                    var targetString = target ? JSON.stringify(target) : undefined;
                    throw "Can't apply 'sickle', invalid target: " + targetString;
                }
                if (target.queue.length === 0) {
                    throw "Production queue is empty";
                }
                if (new Date().getTime() < target.endTime) {
                    throw "Field is not ready yet. It will be ready after " + (target.endTime - new Date().getTime()) + " milliseconds";
                }
                var reaped = target.queue.shift();
                target.endTime = undefined;
                target.currentProductionTimeLeft = undefined;
                bag.increaseCount(reaped.id, reaped.harvestValue);
                return utils.copy(target);
            }
        }),
        wheat: new Plant({
            id: "wheat",
            preparationTime: 10000,
            harvestValue: 3
        }),
        carrot: new Plant({
            id: "carrot",
            preparationTime: 50000,
            harvestValue: 3
        }),
        ground: new Item({
            id: "ground",
            type: itemTypes.foundation
        }),
        field: new Field({
            id: "field"
        }),
        well: new Item({
            id: "well",
            type: itemTypes.building
        })
    };

    this.getItemTypes = function () {
        return utils.copy(itemTypes);
    };

    this.getItems = function () {
        return utils.copy(items);
    };
}

var staticData = new StaticData();