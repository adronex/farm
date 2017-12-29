function Worker()
    local id = "Uasya"
    local hand = {}
    local position = {
        row = 2,
        col = 3
    }
    local assign = function(newRow, newCol)
        if newRow < 1 or newRow > farm.width
                or newCol < 1 or newCol > farm.height then
            error("Trying to assing worker out of farm bounds, row: " .. newRow .. ", col: " .. newCol)
        end
        if farm[newRow][newCol].type ~= staticData.getItems().road then
            error("Target is not the road but " .. farm[newRow][newCol].type)
        end
        position.row = newRow
        position.col = newCol
    end
    local move = function(self, direction)
        local newRow = position.row
        local newCol = position.col
        if direction == "UP" then
            newRow = newRow - 1
        elseif direction == "DOWN" then
            newRow = newRow + 1
        elseif direction == "LEFT" then
            newCol = newCol - 1
        elseif direction == "RIGHT" then
            newCol = newCol + 1
        else
            error("Unknown direction: " .. direction);
        end
        if newRow < 1 or newRow > farm.width
                or newCol < 1 or newCol > farm.height then
            error("Trying to move out of farm bounds, row: " .. newRow .. ", col: " .. newCol)
        end
        self:apply(newRow, newCol)
    end
    local apply = function(self, newRow, newCol)
        if newRow < 1 or newRow > farm.width
                or newCol < 1 or newCol > farm.height then
            error("Trying to move out of farm bounds, row: " .. newRow .. ", col: " .. newCol)
        end
        farm.applyWorkerToCell(self, {row = newRow, col = newCol})
    end
    return {
        id = id,
        hand = hand,
        position = position,
        assign = assign,
        move = move,
        apply = apply
    }
end

workers = { Worker() }