local mod = dmhub.GetModLoading()

function pretty(obj, depth, objects)
    depth = depth or 0
    objects = objects or {}
    if depth > 12 then
        return "...too deep..."
    end
    local indent = string.rep("  ", depth)
    local objType = type(obj)
    if objType == "table" then
        if objects[obj] then
            return "...repeated object..."
        end
        objects[obj] = true
        local result = "\n" .. indent .. "{"
        for k, v in sorted_pairs(obj) do
            if not string.starts_with(k, "_tmp_") then
                result = result .. "\n" .. indent .. tostring(k) .. ": " .. pretty(v, depth+1, objects) .. ","
            end
        end
        if depth > 0 then
            indent = string.rep("  ", depth-1)
        end
        return result .. "\n" .. indent .. "}"
    elseif objType == "string" then
        return '"' .. obj .. '"'
    else
        return tostring(obj)
    end
end