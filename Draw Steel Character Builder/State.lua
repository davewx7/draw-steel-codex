--- Manages state for the character builder
--- @class CharacterBuilderState
--- @field data table The root data table containing all state
local CharacterBuilderState = RegisterGameType("CharacterBuilderState")
CharacterBuilderState.__index = CharacterBuilderState

--- Creates a new CharacterBuilderState instance
--- @return CharacterBuilderState
function CharacterBuilderState:new()
    local instance = setmetatable({}, self)
    instance.data = {}
    return instance
end

--- Sets a value at the specified path in the data table
--- Creates intermediate tables as needed
--- @param key string Dot-separated path (e.g., "path.to.value")
--- @param value any The value to set at the path
function CharacterBuilderState:Set(key, value)
    local parts = {}
    for part in key:gmatch("[^.]+") do
        parts[#parts + 1] = part
    end

    local current = self.data

    -- Navigate/create path up to the last key
    for i = 1, #parts - 1 do
        if current[parts[i]] == nil then
            current[parts[i]] = {}
        end
        current = current[parts[i]]
    end

    -- Set the final value
    current[parts[#parts]] = value
end

--- Gets a value at the specified path in the data table
--- @param key string Dot-separated path (e.g., "path.to.value")
--- @return any|nil The value at the path, or nil if any part doesn't exist
function CharacterBuilderState:Get(key)
    local parts = {}
    for part in key:gmatch("[^.]+") do
        parts[#parts + 1] = part
    end

    local current = self.data

    -- Navigate through the path
    for i = 1, #parts do
        if current == nil or type(current) ~= "table" then
            return nil
        end
        current = current[parts[i]]
    end

    return current
end
