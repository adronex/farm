json = require "json"

function getDataAsString()
    local jsonString = "{\"bag\":[{\"item\":{\"id\":\"softMoney\",\"type\":\"currency\"},\"count\":20},{\"item\":{\"id\":\"wheat\",\"type\":\"plant\",\"preparationTime\":10000,\"harvestValue\":3},\"count\":2},{\"item\":{\"id\":\"wateringCan\",\"type\":\"tool\"},\"count\":1}],\"farm\":[[{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0}],[{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0}],[{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0}],[{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0}],[{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0}],[{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0}],[{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0}],[{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0}],[{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0}],[{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0},{\"id\":\"ground\",\"type\":\"foundation\",\"currentProductionTimeLeft\":0}]],\"shop\":[{\"item\":{\"id\":\"field\",\"type\":\"field\",\"queue\":[]},\"buyPrice\":4,\"sellPrice\":1},{\"item\":{\"id\":\"well\",\"type\":\"building\"},\"buyPrice\":0,\"sellPrice\":0},{\"item\":{\"id\":\"wateringCan\",\"type\":\"tool\"},\"buyPrice\":0,\"sellPrice\":0},{\"item\":{\"id\":\"sickle\",\"type\":\"tool\"},\"buyPrice\":0,\"sellPrice\":0},{\"item\":{\"id\":\"wheat\",\"type\":\"plant\",\"preparationTime\":10000,\"harvestValue\":3},\"buyPrice\":3,\"sellPrice\":1},{\"item\":{\"id\":\"carrot\",\"type\":\"plant\",\"preparationTime\":50000,\"harvestValue\":3},\"buyPrice\":15,\"sellPrice\":3}]}"
    local data = json.decode(jsonString)
    return json.encode(jsonString)
end