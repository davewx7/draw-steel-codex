--- @class PDFDocumentAsset:GameAsset 
--- @field hasBookmarks boolean 
--- @field cachePath string 
PDFDocumentAsset = {}

--- SetBookmarks
--- @param toc any
--- @param parentGuid string?
--- @param level number?
--- @return nil
function PDFDocumentAsset:SetBookmarks(toc, parentGuid, level)
	-- dummy implementation for documentation purposes only
end

--- Sync
--- @return boolean
function PDFDocumentAsset:Sync()
	-- dummy implementation for documentation purposes only
end
