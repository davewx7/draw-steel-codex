--- @class GameCommand 
--- @field executing boolean 
--- @field busy boolean 
GameCommand = {}

--- AddCommandToGroup
--- @param cmd any
--- @return nil
function GameCommand:AddCommandToGroup(cmd)
	-- dummy implementation for documentation purposes only
end

--- Execute
--- @param isRedo boolean?
--- @return nil
function GameCommand:Execute(isRedo)
	-- dummy implementation for documentation purposes only
end

--- Undo
--- @return nil
function GameCommand:Undo()
	-- dummy implementation for documentation purposes only
end
