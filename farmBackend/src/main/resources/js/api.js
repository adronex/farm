var commands = {
    get: "GET",
    buy: "BUY",
    sell: "SELL",
    apply: "APPLY"
};

function setStateFromString(dataString) {
    var data = JSON.parse(dataString);
    bag = new Bag(data.bag);
    farm = new Farm(data.farm);
    shop = new Shop();
}

function getDataAsString() {
    return JSON.stringify({bag: bag.getCopyOfAllItems(), farm: farm.getOriginalFarmObject(), shop: shop.getCopyOfAllItems()});
}

function commandHandler(requestString) {
    var requestArray = JSON.parse(requestString);
    if (Array.isArray(requestArray)) {
        for (var i = 0; i < requestArray.length; i++) {
            var requestObject = requestArray[i];
            switch (requestObject.command) {
                case commands.get:
                    return getDataAsString();
                case commands.buy:
                    shop.buy(requestObject.hand.id);
                    break;
                case commands.sell:
                    shop.sell(requestObject.hand.id);
                    break;
                case commands.apply:
                    farm.applyHandToCell(requestObject.hand, requestObject.target);
                    break;
                default:
                    throw "API didn't recognised request object: " + JSON.stringify(requestObject);
            }
        }
        return getDataAsString();
    }
    throw "API didn't recognised request array: " + JSON.stringify(requestArray);
}

function Utils() {

    // ES6 Array.find substitution
    this.findInArray = function (array, fun) {
        for (var i = 0; i < array.length; i++) {
            if (fun(array[i])) {
                return array[i];
            }
        }
        return undefined;
    };

    // ES6 Array.map substitution
    this.mapArray = function (source, fun) {
        var target = [];
        for (var i = 0; i < source.length; i++) {
            target.push(fun(source[i]));
        }
        return target;
    };

    // ES6 Object.assign substitution
    this.copy = function (obj) {
        if (null === obj || "object" !== typeof obj) return obj;
        var out, v, key;
        out = Array.isArray(obj) ? [] : {};
        for (key in obj) {
            v = obj[key];
            out[key] = (typeof v === "object") ? this.copy(v) : v;
        }
        return out;
    };
}

var utils = new Utils();