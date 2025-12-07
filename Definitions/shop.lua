--- @class shop 
--- @field events any 
--- @field inventoryItems any 
shop = {}

--- ItemInInventory
--- @param itemid string
--- @return boolean
function shop:ItemInInventory(itemid)
	-- dummy implementation for documentation purposes only
end

--- AcknowledgeNewInventoryItems
--- @return any
function shop:AcknowledgeNewInventoryItems()
	-- dummy implementation for documentation purposes only
end

--- CheckoutSubscription
--- @param tier number
--- @return nil
function shop:CheckoutSubscription(tier)
	-- dummy implementation for documentation purposes only
end

--- Checkout
--- @param items any
--- @param args any
--- @return nil
function shop:Checkout(items, args)
	-- dummy implementation for documentation purposes only
end

--- QueryGiftCode
--- @param code string
--- @param callback any
--- @param errorCallback any
--- @return nil
function shop:QueryGiftCode(code, callback, errorCallback)
	-- dummy implementation for documentation purposes only
end

--- AdminSetGiftCodeNote
--- @param code string
--- @param note string
--- @return nil
function shop:AdminSetGiftCodeNote(code, note)
	-- dummy implementation for documentation purposes only
end

--- AdminCreateGiftCode
--- @param code string
--- @param data any
--- @return nil
function shop:AdminCreateGiftCode(code, data)
	-- dummy implementation for documentation purposes only
end

--- MonitorItemGiftCodes
--- @param itemid string
--- @return any
function shop:MonitorItemGiftCodes(itemid)
	-- dummy implementation for documentation purposes only
end

--- RetrieveGiftCodes
--- @param callback any
--- @param errorCallback any
--- @param completeCallback any
--- @return number
function shop:RetrieveGiftCodes(callback, errorCallback, completeCallback)
	-- dummy implementation for documentation purposes only
end
