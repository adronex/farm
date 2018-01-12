--local createObject = function(type, id)
--    if type ==
--end

local createPickable = function(type, id)
    local category = pickableObjects[type]
    if not category then
        error("No pickable objects of type " .. type .. " are present")
    end
    local item = category[id]
    if not item then
        error("No item of category '" .. type .. "' with id '" .. id .. "' is present")
    end
    return item
end