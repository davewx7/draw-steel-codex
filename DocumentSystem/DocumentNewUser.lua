local mod = dmhub.GetModLoading()

dmhub.RegisterEventHandler("EnterGame", function()
    if dmhub.isDM or dmhub.currentToken ~= nil then
        print("EnterGame: HAS TOKEN")
        return
    end

    dmhub.Coroutine(function()

        while (not GameHud.instance) or (not GameHud.instance.documentsPanel) or (not GameHud.instance.documentsPanel.valid) do
            coroutine.yield()
        end

        for i=1,5 do
            coroutine.yield()
        end

        print("EnterGame: Display")

        local description = string.lower("New Player Welcome")
        local customDocs = dmhub.GetTable(CustomDocument.tableName) or {}
        for k,doc in unhidden_pairs(customDocs) do
            if string.lower(doc.description) == description then
                print("EnterGame: ShowDocument")
                doc:ShowDocument()
                return
            end
        end
    end)
end)

print("Loaded:: xxx")