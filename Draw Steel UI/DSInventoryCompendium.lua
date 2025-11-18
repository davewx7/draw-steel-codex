local mod = dmhub.GetModLoading()


local ShowInventoryPanel = function(parentPanel, categories)
	local itemsPanel = gui.Panel{
		styles = Compendium.Styles,
		width = 1200,
		height = 1000,
		Compendium.InventoryEditor(categories),
	}

	parentPanel.children = {itemsPanel}
end

Compendium.RegisterSection{
    text = "Inventory",
    ord = 15,
}

Compendium.Register{
    section = "Inventory",
    text = 'Inventory',
    contentType = "tbl_Gear",
    priority = 1, --override previous versions.
    click = function(contentPanel)
        ShowInventoryPanel(contentPanel)
    end,
}

Compendium.Register{
    section = "Inventory",
    text = 'Lights',
    contentType = "tbl_Gear",
    click = function(contentPanel)
        ShowInventoryPanel(contentPanel, {EquipmentCategory.LightSourceId})
    end,
}

