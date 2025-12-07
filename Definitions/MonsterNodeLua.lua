--- @class MonsterNodeLua 
--- @field hidden boolean (Read-only) true if the entry has been 'hidden' in this game (i.e. deleted, but can be undeleted)
--- @field ord number The ordering of the node, controls whether it is displayed before or after its siblings.
--- @field description string 
--- @field monster nil|MonsterAssetLua (Read-only) Get the monster entry if this is a monster, or nil if it's actually a folder.
--- @field folder nil|MonsterFolderLua (Read-only) Get the folder entry if this is a folder, or nil if it's actually a monster.
--- @field children MonsterNodeLua[] 
--- @field parentNode string 
MonsterNodeLua = {}

--- Duplicate: Create a duplicate of this entry in the bestiary.
--- @return nil
function MonsterNodeLua:Duplicate()
	-- dummy implementation for documentation purposes only
end

--- Upload: Save any changes made to this entry to the cloud.
--- @return nil
function MonsterNodeLua:Upload()
	-- dummy implementation for documentation purposes only
end

--- Delete: Delete this bestiary entry.
--- @return nil
function MonsterNodeLua:Delete()
	-- dummy implementation for documentation purposes only
end

--- ObliterateGameChanges: Destroy any changes made to this bestiary entry in this game. If it was first created in this game it will be destroyed and unrecoverable.
--- @return nil
function MonsterNodeLua:ObliterateGameChanges()
	-- dummy implementation for documentation purposes only
end

--- MatchesSearch: Given a search string, returns true if the entry matches it.
--- @param text string
--- @return boolean
function MonsterNodeLua:MatchesSearch(text)
	-- dummy implementation for documentation purposes only
end
