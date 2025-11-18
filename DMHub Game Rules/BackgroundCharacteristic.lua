local mod = dmhub.GetModLoading()

RegisterGameType("BackgroundCharacteristic")


BackgroundCharacteristic.characteristicsTable = "characteristicsTable"

function BackgroundCharacteristic:GetRollTable()
    local rollData = dmhub.GetTable(BackgroundCharacteristic.characteristicsTable)
    return rollData[self.tableid]
end

function BackgroundCharacteristic:Name()
    return self:GetRollTable().name
end

function BackgroundCharacteristic:GetRulesText()
    return self:GetRollTable().details
end

function BackgroundCharacteristic.CreateNew()

    local rollTable = RollTable.CreateNew{
        text = true,
        items = false,
    }

    dmhub.SetAndUploadTableItem(BackgroundCharacteristic.characteristicsTable, rollTable)

    return BackgroundCharacteristic.new{
        tableid = rollTable.id,
    }
end

function BackgroundCharacteristic:CreateEditor(args)
    local resultPanel
    local tableEditor = RollTable.CreateEditor{
        styles = {
            {
                selectors = {"plus-button"},
                priority = 5,
                hidden = 1,
            },
            {
                selectors = {"input", "variantInput"},
                width = "90%",
            }
        },
        changename = function(element)
            resultPanel:FireEvent("change")
        end,
		change = function(element)
		end,
    }
    tableEditor.data.SetData(BackgroundCharacteristic.characteristicsTable, self.tableid, {
        hasDetails = true,
    })

    resultPanel = {
        width = 800,
        height = "auto",
        flow = "vertical",

        tableEditor,
    }

    for k,v in pairs(args or {}) do
        resultPanel[k] = v
    end

    resultPanel = gui.Panel(resultPanel)

    return resultPanel
end

--embed a background characteristic editor in a "parentFeature" like a background or a character type.
--children is a list of panels.
function BackgroundCharacteristic.EmbedEditor(parentFeature, children, onchange)
    
	local characteristicsPanel = gui.Panel{
		width = "auto",
		height = "auto",
		flow = "vertical",
	}

	children[#children+1] = characteristicsPanel

	local m_expandedCharacteristics = {}

	local RefreshCharacteristics
	RefreshCharacteristics = function()

		local characteristicsPanels = {}

		for i,characteristic in ipairs(parentFeature:try_get("characteristics", {})) do

			--starting equipment editor.
			characteristicsPanels[#characteristicsPanels+1] = gui.Panel{
				width = "auto",
				height = "auto",
				flow = "vertical",
				gui.Panel{
					flow = "horizontal",
					width = "auto",
					height = 30,
					bgimage = "panels/square.png",
					bgcolor = "clear",

					rightClick = function(element)
						element.popup = gui.ContextMenu{
							entries = {
								{
									text = "Delete",
									click = function()
										m_expandedCharacteristics = {}
										table.remove(parentFeature.characteristics, i)
                                        onchange()
                                        RefreshCharacteristics()
										element.popup = nil
									end,
								}
							}
						}
					end,

					press = function(element)
						local tri = element.children[1]
						tri:SetClass("expanded", not tri:HasClass("expanded"))

						local siblings = element.parent.children
						if #siblings == 1 then
							siblings[#siblings+1] = characteristic:CreateEditor{
								change = function(element)
                                    onchange()
                                    RefreshCharacteristics()
								end,
							}

							element.parent.children = siblings
						end

						siblings[2]:SetClass("collapsed", not tri:HasClass("expanded"))
						m_expandedCharacteristics[i] = tri:HasClass("expanded")
					end,

					gui.Panel{
						classes = {"triangle"},
						height = 12,
						width = "100% height",
						halign = "left",
						valign = "center",
						bgimage = "panels/triangle.png",
						bgcolor = "white",
						styles = Styles.triangleStyles,
					},

					gui.Label{
						text = string.format("Characteristic: %s", characteristic:Name()),
						fontSize = 20,
						hmargin = 4,
						color = "white",
						width = "auto",
						height = "auto",
						valign = "center",
					}
				},
			}

			if m_expandedCharacteristics[i] then
				--maintain expansion of characteristics.
				characteristicsPanels[#characteristicsPanels].children[1]:FireEvent("press")
			end
		end

		characteristicsPanel.children = characteristicsPanels
	end

	RefreshCharacteristics()
	
	children[#children+1] = gui.PrettyButton{
		text = "Add Characteristic",
		click = function(element)
			local newCharacteristic = BackgroundCharacteristic.CreateNew()

			local characteristics = parentFeature:get_or_add("characteristics", {})
			characteristics[#characteristics+1] = newCharacteristic

            onchange()
            RefreshCharacteristics()
		end,
	}
end