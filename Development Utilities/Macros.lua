local mod = dmhub.GetModLoading()

local g_checkpoint = nil

Commands.checkpoint = function(str)
    g_checkpoint = backup.CreateCombatCheckpoint()
end

Commands.restorecheckpoint = function(str)
    if g_checkpoint == nil then
        print("No checkpoint to restore")
        return
    end

    print("Checkpoint: restoring...")
    g_checkpoint:Restore()
end

Commands.despawn = function(str)
    local selected = dmhub.selectedTokens
    for _,tok in ipairs(selected) do
        tok.despawned = true
    end

    print("Despawned tokens:", dmhub.despawnedTokensCount)
end

Commands.recovercompendium = function(str)
    print("RECOVER::", str)
    local data = dmhub.ParseJsonFile("c:\\Users\\davew\\Downloads\\gertz-backup.json")
    print("RECOVER::", data.assets.objectTables)
    local objectTables = data.assets.objectTables
    dmhub.Coroutine(function()
        for tableName,tableInfo in pairs(objectTables) do
            for k,v in unhidden_pairs(tableInfo.table) do
                print("RECOVER:: Uploading", tableName, k, rawget(v, "name"))
                dmhub.SetAndUploadTableItem(tableName, v, {deferUpload = true})
                local t = dmhub.Time()
                while dmhub.Time() < t + 1 do
                    coroutine.yield(1)
                end
            end
        end
    end)
end

Commands.skillfind = function(str)
    local s = Skill.FindByName(str)
    print("SKILL::", s)
end

Commands.showtriggers = function(str)
    local tokens = dmhub.selectedTokens
    for _,tok in ipairs(tokens) do
        print("TRIGGERS:: TRIGGERS named", str, "for", tok.name)

        local mods = tok.properties:GetActiveModifiers()
	    for i,mod in ipairs(mods) do
            if mod.mod:HasTriggeredEvent(tok.properties, str) then
                print("TRIGGERS::   Mod", json(mod))
            end
        end

    end
end