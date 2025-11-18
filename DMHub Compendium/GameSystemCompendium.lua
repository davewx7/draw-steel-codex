local mod = dmhub.GetModLoading()

local tableName = "GameSystem"

local function InitGameSystem()
    local t = dmhub.GetTable(tableName)

    if t.attackRolls == nil then
        dmhub.SetAndUploadTableItem(tableName, RollRules.new{
            id = "attackRolls",
            name = "Attack Rolls",
        })
    end
end

mod.shared.GameSystemCompendium = function(parentPanel)

    InitGameSystem()

    local dataTable = dmhub.GetTable(tableName)

    local editorPanel = gui.Panel{
        width = 100,
        height = 100,
    }


	local itemsListPanel = nil

	itemsListPanel = gui.Panel{
		classes = {'list-panel'},
		vscroll = true,
        create = function(element)
            local children = {}
            for k,v in pairs(dataTable) do
                children[#children+1] = mod.shared.CreateListItem{
                    tableName = tableName,
                    key = k,
                    text = v.name,
                    click = function()
                        editorPanel:FireEventTree("edit", k, v)
                    end,
                }
            end

            element.children = children
        end,
	}

	local leftPanel = gui.Panel{
		selfStyle = {
			flow = 'vertical',
			height = '100%',
			width = 'auto',
		},

		itemsListPanel,
	}

	parentPanel.children = {leftPanel, editorPanel}
end