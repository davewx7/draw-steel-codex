local mod = dmhub.GetModLoading()
--[[
DockablePanel.Register{
	name = "Status Bar",
	icon = mod.images.chatIcon,
	minHeight = 20,
	maxHeight = 20,
	vscroll = false,
    notitle = true,
	content = function()
        return gui.Label{
            width = "100%",
            height = "100%",
            fontSize = 14,
            minFontSize = 6,
            text = "",
            interactable = false,

            thinkTime = 0.1,

            think = function(element)
                element.text = dmhub.status
            end,

        }
	end,
}
]]