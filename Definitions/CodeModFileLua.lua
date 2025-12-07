--- @class CodeModFileLua 
--- @field usingGit boolean 
--- @field hasMerge boolean 
--- @field valid boolean 
--- @field hasLocalChanges boolean 
--- @field localContents any 
--- @field revisions any 
--- @field numRevisions any 
--- @field changeTimestamp any 
--- @field name string 
CodeModFileLua = {}

--- MatchesSearch
--- @param search string
--- @param options any
--- @return boolean
function CodeModFileLua:MatchesSearch(search, options)
	-- dummy implementation for documentation purposes only
end

--- SyncLocally
--- @param revision any
--- @return nil
function CodeModFileLua:SyncLocally(revision)
	-- dummy implementation for documentation purposes only
end

--- LaunchExternalDiffWithLocal
--- @return nil
function CodeModFileLua:LaunchExternalDiffWithLocal()
	-- dummy implementation for documentation purposes only
end
