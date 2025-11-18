local mod = dmhub.GetModLoading()

CodexQuotes = {
    quotes = {}
}

CodexQuotes.Register = function(entry)
    CodexQuotes.quotes[entry.id] = entry
end

CodexQuotes.SelectQuote = function()
    local entries = table.values(CodexQuotes.quotes)
    if #entries == 0 then
        return nil
    end
    local result = entries[math.random(1, #entries)]
    return result
end