function Worker()
    local name = "Uasya"
    local hand = {}
    local position = {
        x = nil,
        y = nil
    }
    local assign = function(newX, newY)
        if newX < 1 or newX > farm.width
                or newY < 1 or newY > farm.height then
            error("Trying to assing worker out of farm bounds, x: "..newX..", y: "..newY)
        end
        if farm[newX][newY].type ~= staticData.getItems().road then
            error("Target is not the road but "..farm[newX][newY].type)
        end
        position.x = newX
        position.y = newY
    end
    local move = function(self, direction)
        local newX = position.x
        local newY = position.y
        if direction == "UP" then
            newY = newY - 1
        end
        if direction == "DOWN" then
            newY = newY + 1
        end
        if direction == "LEFT" then
            newX = newX - 1
        end
        if direction == "RIGHT" then
            newX = newX + 1
        end
        if newX < 1 or newX > farm.width
                or newY < 1 or newY > farm.height then
            error("Trying to move out of farm bounds, x: "..newX..", y: "..newY)
        end
        apply(self, newX, newY)
    end
    local apply = function(self, newX, newY)
        if newX < 1 or newX > farm.width
                or newY < 1 or newY > farm.height then
            error("Trying to move out of farm bounds, x: "..newX..", y: "..newY)
        end
        farm.applyHandToCell(hand, farm[newX][newY], self)
    end
    return {
        name = name,
        position = position,
        assign = assign,
        move = move
    }
end

workers = { Worker(), Worker() }