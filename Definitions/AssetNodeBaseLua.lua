--- @class AssetNodeBaseLua 
--- @field hidden boolean True if the entry has been 'hidden' in this game (i.e. deleted, but can be undeleted)
--- @field artist string The content creator who created this content.
--- @field imageFileId string 
--- @field ord number 
--- @field description any 
--- @field parentFolder string 
--- @field parentNode any 
--- @field children any 
AssetNodeBaseLua = {}

--- Backup: Returns a json representation of this node.
--- @return string
function AssetNodeBaseLua:Backup()
	-- dummy implementation for documentation purposes only
end

--- Restore: Restores this from json.
--- @param json string
--- @return nil
function AssetNodeBaseLua:Restore(json)
	-- dummy implementation for documentation purposes only
end

--- OpenImageUrl: Open the image for this content in a web browser.
--- @return nil
function AssetNodeBaseLua:OpenImageUrl()
	-- dummy implementation for documentation purposes only
end

--- MatchesSearch
--- @param text any
--- @return any
function AssetNodeBaseLua:MatchesSearch(text)
	-- dummy implementation for documentation purposes only
end

--- GetNodeIdsMatchingSearch
--- @param text any
--- @return any
function AssetNodeBaseLua:GetNodeIdsMatchingSearch(text)
	-- dummy implementation for documentation purposes only
end
