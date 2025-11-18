local mod = dmhub.GetModLoading()

local DSTestPanel = {}

function DSTestPanel.MainSheet()

end
--[[
CharSheet.RegisterTab{
    id = "DS Test Panel",
    text = "DS Test Panel",
    panel = DSTestPanel.MainSheet,
    order = 'zzz'
}

dmhub.RefreshCharacterSheet()
]]