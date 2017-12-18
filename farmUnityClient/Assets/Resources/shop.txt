function Shop() {
    var shopItems = [
        {
            item: staticData.getItems().field,
            buyPrice: 4,
            sellPrice: 1
        },
        {
            item: staticData.getItems().well,
            buyPrice: 0,
            sellPrice: 0
        },
        {
            item: staticData.getItems().wateringCan,
            buyPrice: 0,
            sellPrice: 0
        },
        {
            item: staticData.getItems().sickle,
            buyPrice: 0,
            sellPrice: 0
        },
        {
            item: staticData.getItems().wheat,
            buyPrice: 3,
            sellPrice: 1
        },
        {
            item: staticData.getItems().carrot,
            buyPrice: 15,
            sellPrice: 3
        }
    ];
    var findShopItem = function (itemId) {
        return utils.findInArray(shopItems, function (it) {
            return it.item.id === itemId;
        });
    };

    this.getCopy = function (itemId) {
        var item = findShopItem(itemId);
        if (!item) {
            return undefined;
        }
        return utils.copy(item);
    };

    this.getCopyOfAllItems = function() {
        return utils.copy(shopItems);
    };
    
    this.buy = function (itemId) {
        var item = findShopItem(itemId);
        if (!item) {
            throw "There is no shop item with id " + itemId;
        }
        // reduce count in shop if needed
        bag.decreaseCount(staticData.getItems().softMoney.id, item.buyPrice);
        bag.increaseCount(item.item.id, 1);
    };

    this.sell = function (itemId) {
        var count = bag.getOrCreate(itemId).count;
        if (count === 0) {
            throw "Bag doesn't contain enough items with id " + itemId;
        }
        var item = findShopItem(itemId);
        if (!item) {
            throw "You can't sell item with id " + itemId + "because shop doesn't contain it";
        }
        // reduce count in shop if needed
        bag.decreaseCount(item.item.id, 1);
        bag.increaseCount(staticData.getItems().softMoney.id, item.sellPrice);
    };
}

var shop = new Shop();