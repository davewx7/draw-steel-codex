local mod = dmhub.GetModLoading()


LaunchablePanel.Register{
	name = "Blur",
    folder = "Development Tools",

	halign = "center",
	valign = "center",
    draggable = true,

	content = function(args)
        local resultPanel

        resultPanel = gui.Panel{
            halign = "center",
            valign = "center",
            width = 600,
            height = 400,
            bgcolor = "#00000000",
            bgimage = true,
            interactable = false,
            x = 600,
            blurBackground = true,
            
        }

        return resultPanel
	end,
}