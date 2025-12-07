--- @class import 
--- @field importers any 
--- @field importedAssets any 
--- @field pendingUpload boolean 
--- @field error any 
--- @field uploadCostKB number 
--- @field haveEnoughBandwidth boolean 
import = {}

--- CreateImporter
--- @return any
function import.CreateImporter()
	-- dummy implementation for documentation purposes only
end

--- BookmarkLog
--- @return number
function import:BookmarkLog()
	-- dummy implementation for documentation purposes only
end

--- IsReimport
--- @param asset any
--- @return boolean
function import:IsReimport(asset)
	-- dummy implementation for documentation purposes only
end

--- GetAssetLog
--- @param asset any
--- @return any
function import:GetAssetLog(asset)
	-- dummy implementation for documentation purposes only
end

--- GetImage
--- @param asset any
--- @return any
function import:GetImage(asset)
	-- dummy implementation for documentation purposes only
end

--- StoreLogFromBookmark
--- @param bookmark number
--- @param asset any
--- @return nil
function import:StoreLogFromBookmark(bookmark, asset)
	-- dummy implementation for documentation purposes only
end

--- GetLog
--- @return any
function import:GetLog()
	-- dummy implementation for documentation purposes only
end

--- CreateCharacter
--- @return any
function import:CreateCharacter()
	-- dummy implementation for documentation purposes only
end

--- CreateMonster
--- @return any
function import:CreateMonster()
	-- dummy implementation for documentation purposes only
end

--- CreateMonsterFolder
--- @param description string
--- @return any
function import:CreateMonsterFolder(description)
	-- dummy implementation for documentation purposes only
end

--- GetExistingItem
--- @param tableName string
--- @param itemName string
--- @return any
function import:GetExistingItem(tableName, itemName)
	-- dummy implementation for documentation purposes only
end

--- GetImports
--- @return any
function import:GetImports()
	-- dummy implementation for documentation purposes only
end

--- Log
--- @param text any
--- @return nil
function import:Log(text)
	-- dummy implementation for documentation purposes only
end

--- OnImportConfirmed
--- @param fn any
--- @return nil
function import:OnImportConfirmed(fn)
	-- dummy implementation for documentation purposes only
end

--- ImportMonsterFolder
--- @param asset any
--- @return nil
function import:ImportMonsterFolder(asset)
	-- dummy implementation for documentation purposes only
end

--- ImportMonster
--- @param asset any
--- @return nil
function import:ImportMonster(asset)
	-- dummy implementation for documentation purposes only
end

--- ImportCharacter
--- @param asset any
--- @return string
function import:ImportCharacter(asset)
	-- dummy implementation for documentation purposes only
end

--- ImportAsset
--- @param tableName string
--- @param asset any
--- @return nil
function import:ImportAsset(tableName, asset)
	-- dummy implementation for documentation purposes only
end

--- SetImportRemoved
--- @param id string
--- @param remove boolean
--- @return nil
function import:SetImportRemoved(id, remove)
	-- dummy implementation for documentation purposes only
end

--- CompleteImportStep
--- @return boolean
function import:CompleteImportStep()
	-- dummy implementation for documentation purposes only
end

--- Register
--- @param options any
--- @return nil
function import.Register(options)
	-- dummy implementation for documentation purposes only
end

--- GetCurrentImporter
--- @return any
function import:GetCurrentImporter()
	-- dummy implementation for documentation purposes only
end

--- ImportPlainText
--- @param text string
--- @return nil
function import:ImportPlainText(text)
	-- dummy implementation for documentation purposes only
end

--- ImportFromText
--- @param text string
--- @return nil
function import:ImportFromText(text)
	-- dummy implementation for documentation purposes only
end

--- SetActiveImporter
--- @param importerid any
--- @return nil
function import:SetActiveImporter(importerid)
	-- dummy implementation for documentation purposes only
end

--- ImportFromJson
--- @param obj any
--- @param filename any
--- @return nil
function import:ImportFromJson(obj, filename)
	-- dummy implementation for documentation purposes only
end

--- ImportImageFromURL
--- @param url string
--- @param success any
--- @param error any
--- @param options any
--- @return nil
function import:ImportImageFromURL(url, success, error, options)
	-- dummy implementation for documentation purposes only
end

--- ClearState
--- @return nil
function import:ClearState()
	-- dummy implementation for documentation purposes only
end
