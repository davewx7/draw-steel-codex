local mod = dmhub.GetModLoading()

Commands.toggletokenvision = function(s)
    if not dmhub.isDM then
        return
    end
    local selected = dmhub.selectedTokens
    local tokenids = {}
    for _,token in ipairs(selected) do
        tokenids[#tokenids + 1] = token.charid
    end

    if dmhub.tokenVision == nil then
        if #tokenids > 0 then
            dmhub.tokenVision = tokenids
        end
    else
        dmhub.tokenVision = nil
    end
end

Keybinds.Register{
    command = "toggletokenvision",
    name = "Show Token Vision",
    dmonly = true,
    section = "camera",
}