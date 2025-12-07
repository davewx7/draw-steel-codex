--- @class PDFDocumentAssetLua 
--- @field nodeType string 
--- @field parentFolder string 
--- @field bookmarks table<string,PDFBookmark> 
--- @field description any 
--- @field ownerid string 
--- @field ord number 
--- @field canView any 
--- @field hiddenFromPlayers any 
--- @field hidden any 
--- @field doc PDFDocument 
PDFDocumentAssetLua = {}

--- HaveReadPermissions
--- @return any
function PDFDocumentAssetLua:HaveReadPermissions()
	-- dummy implementation for documentation purposes only
end

--- HaveEditPermissions
--- @return boolean
function PDFDocumentAssetLua:HaveEditPermissions()
	-- dummy implementation for documentation purposes only
end

--- Upload
--- @return nil
function PDFDocumentAssetLua:Upload()
	-- dummy implementation for documentation purposes only
end
