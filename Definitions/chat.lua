--- @class chat 
--- @field events EventSourceLua An event source that you can subscribe to for chat events.
--- @field messages ChatMessageInfoLua[] All messages in the chat.
chat = {}

--- DiceEvents: Given a dice roll, returns an event source you can subscribe to to get events for the dice.
--- @param guid string
--- @return EventSourceLua
function chat.DiceEvents(guid)
	-- dummy implementation for documentation purposes only
end

--- Send: Send a message to the chat.
--- @param message string
function chat.Send(message)
	-- dummy implementation for documentation purposes only
end

--- SendCustom: Send a CustomChatPanel to chat.
--- @param panel CustomChatPanel
--- @return string The guid of the message.
function chat.SendCustom(panel)
	-- dummy implementation for documentation purposes only
end

--- UpdateCustom: Updates a CustomChatPanel in chat. The key is the guid previously returned by @see SendCustom
--- @param key string
--- @param properties CustomChatPanel
function chat.UpdateCustom(key, properties)
	-- dummy implementation for documentation purposes only
end

--- ShareData: Share a game object (e.g. a spell, ability, or item) to the chat.
--- @param data table
function chat.ShareData(data)
	-- dummy implementation for documentation purposes only
end

--- ShareObjectInfo
--- @param tableid string
--- @param objid string
--- @param properties any?
--- @return nil
function chat.ShareObjectInfo(tableid, objid, properties)
	-- dummy implementation for documentation purposes only
end

--- Clear: Clear the chat.
--- @return nil
function chat.Clear()
	-- dummy implementation for documentation purposes only
end

--- PreviewChat
--- @param message any
--- @return nil
function chat.PreviewChat(message)
	-- dummy implementation for documentation purposes only
end

--- GetCommandCompletions
--- @param command string
--- @return any
function chat.GetCommandCompletions(command)
	-- dummy implementation for documentation purposes only
end

--- GetRollInfo
--- @param key string
--- @return any
function chat.GetRollInfo(key)
	-- dummy implementation for documentation purposes only
end
