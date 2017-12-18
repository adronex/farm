function Bag(exportData) {
    var bagItems;
    if (exportData && Array.isArray(exportData)) {
        bagItems = exportData;
    } else {
        bagItems = [
            {
                item: staticData.getItems().softMoney,
                count: 20
            },
            {
                item: staticData.getItems().wheat,
                count: 2
            },
            {
                item: staticData.getItems().wateringCan,
                count: 1
            }
        ];
    }

    this.getOrCreate = function (itemId) {
        var found = utils.findInArray(bagItems, function (it) {
            return it.item.id === itemId;
        });
        if (found) {
            return found;
        } else {
            found = staticData.getItems()[itemId];
        }
        if (!found) {
            throw "No item with id '" + itemId + "' have been found in application";
        }
        var newBagItem = {item: found, count: 0};
        bagItems.push(newBagItem);
        return newBagItem;
    };

    this.decreaseCount = function (itemId, count) {
        var found = this.getOrCreate(itemId);
        if (found.count < count) {
            throw "Not enough '" + itemId + "', need: " + count + ", available: " + found.count;
        }
        found.count -= count;
    };

    this.increaseCount = function (itemId, count) {
        this.getOrCreate(itemId).count += count;
    };

    this.getCopyOfAllItems = function () {
        return utils.copy(bagItems);
    }
}

var bag = new Bag();


