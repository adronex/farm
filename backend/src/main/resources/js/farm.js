function Farm(exportData) {
    var FIELD_HEIGHT = 10;
    var FIELD_WIDTH = 10;
    var farm;
    if (exportData && Array.isArray(exportData)) {
        farm = exportData;
    } else {
        farm = [];
        for (var i = 0; i < FIELD_HEIGHT; i++) {
            farm.push([]);
            for (var j = 0; j < FIELD_WIDTH; j++) {
                farm[i].push(staticData.getItems().ground);
            }
        }
    }

    this.applyHandToCell = function (hand, target) {
        if (!hand || !hand.id) {
            if (!hand) hand = {};
            throw "Invalid object in hand: " + JSON.stringify(hand);
        }
        if (!target || target.x === undefined || target.y === undefined) {
            if (!target) target = {};
            throw "Invalid target object: " + JSON.stringify(target);
        }
        if (bag.getOrCreate(hand.id).count <= 0) {
            throw "Not enough '" + hand.id + "'. Target: " + JSON.stringify(target) + ". Cell: " + JSON.stringify(farm[target.x][target.y]);
        }
        var item = staticData.getItems()[hand.id];
        farm[target.x][target.y] = item.use(farm[target.x][target.y]);
        bag.decreaseCount(hand.id, 1);
    };

    function updateTimersDeltas() {
        for (var x = 0; x < farm.length; x++) {
            for (var y = 0; y < farm[x].length; y++) {
                if (!farm[x][y]) {
                    continue;
                }
                var delta = farm[x][y].endTime - new Date().getTime();
                if (delta > 0) {
                    farm[x][y].currentProductionTimeLeft = delta;
                } else {
                    farm[x][y].currentProductionTimeLeft = 0;
                }
            }
        }
    }

    this.getOriginalFarmObject = function () {
        updateTimersDeltas();
        return farm;
    }
}

var farm = new Farm();