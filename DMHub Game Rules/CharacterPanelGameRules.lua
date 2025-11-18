local mod = dmhub.GetModLoading()

local RollsStyles = {
	gui.Style{
		selectors = {"rollsPanel"},
		width = "100%",
		height = "auto",
	},
	gui.Style{
		selectors = {"rollsSection"},
		flow = "vertical",
		width = "auto",
		height = "auto",
		vmargin = 12,
	},
	gui.Style{
		selectors = {"rollsDoubleCollection"},
		flow = "horizontal",
		width = "100%",
		height = "auto",
	},
	gui.Style{
		selectors = {"rollsCollection"},
		flow = "vertical",
		halign = "center",
		width = "auto",
		height = "auto",
	},
	gui.Style{
		selectors = {"singleRollPanel"},
		flow = "horizontal",
		bgcolor = "clear",
		width = 144,
		height = 18,
	},
	gui.Style{
		selectors = {"rollTitle"},
		uppercase = true,
		bold = true,
		fontSize = 16,
		color = "#d4d1ba",
		halign = "center",
		width = "auto",
		height = "auto",
	},
	gui.Style{
		selectors = {"rollLabel"},
		fontSize = 14,
		bold = true,
		halign = "left",
		width = "auto",
		height = "auto",
		color = "#d4d1ba",
	},
	gui.Style{
		selectors = {"rollValue"},
		fontSize = 14,
		width = "auto",
		height = "auto",
		bold = true,
		halign = "right",
		color = "#c0eddf",
	},
	gui.Style{
		selectors = {"rollValue", "disadvantage"},
		color = "red",
	},
	gui.Style{
		selectors = {"rollValue", "advantage"},
		color = "green",
	},
	gui.Style{
		selectors = {"rollLabel", "parent:hover"},
		color = "white",
	},
	gui.Style{
		selectors = {"rollLabel", "parent:press"},
		color = "grey",
	},
	gui.Style{
		selectors = {"rollValue", "parent:hover"},
		color = "white",
	},
	gui.Style{
		selectors = {"rollValue", "parent:press"},
		color = "grey",
	},
	gui.Style{
		selectors = {"notesLabel"},
		color = "#d4d1ba",
		fontSize = 14,
		width = "90%",
		height = "auto",
		halign = "center",
	},
}

CharacterPanel.CreateCharacterDetailsPanel = function(tokenArg)

	local token = tokenArg

	local resultPanel = nil

	--INITIATIVE.
	local initiativeAttr = {
		gui.Panel{
			classes = {"singleRollPanel"},
			bgimage = "panels/square.png",
			rightClick = function(element)
				token.properties:RollInitiative()
			end,
			press = function(element)
				token.properties:ShowInitiativeRollDialog()
			end,
			gui.Label{
				classes = {"rollLabel"},
				interactable = false,
				text = "Initiative",
			},
			gui.Label{
				classes = {"rollValue"},
				interactable = false,
				refreshToken = function(element, token)

					local roll = token.properties:GetInitiativeRoll()
					if string.find(roll, "disadvantage") then
						element:SetClass("disadvantage", true)
						element:SetClass("advantage", false)
					elseif string.find(roll, "advantage") then
						element:SetClass("disadvantage", false)
						element:SetClass("advantage", true)
					else
						element:SetClass("disadvantage", false)
						element:SetClass("advantage", false)
					end


					element.text = ModifierStr(token.properties:InitiativeBonus())
				end,
			},
		}
	}

	local initiativePanel = gui.Panel{
		classes = {"rollsDoubleCollection"},
		halign = "center",
		gui.Panel{
			classes = {"rollsCollection"},
			children = initiativeAttr,
		},
		gui.Panel{
			classes = {"rollsCollection"},
			gui.Panel{
				classes = {"singleRollPanel"},
			}
		},

	}


	--BASE ATTRIBUTE ROLLS
	local leftAttr = {}
	local rightAttr = {}
	local attrPanels = leftAttr
	for i,attrid in ipairs(creature.attributeIds) do
		local attrInfo = creature.attributesInfo[attrid]
		if i > #creature.attributeIds/2 then
			attrPanels = rightAttr
		end

		attrPanels[#attrPanels+1] = gui.Panel{
			classes = {"singleRollPanel"},
			bgimage = "panels/square.png",

			rightClick = function(element)
				token.properties:RollAttributeCheck(attrid)
			end,
			press = function(element)
				token.properties:ShowAttributeRollDialog(attrid)
			end,
			gui.Label{
				classes = {"rollLabel"},
				interactable = false,
				text = attrInfo.description,
			},
			gui.Label{
				classes = {"rollValue"},
				interactable = false,
				refreshToken = function(element, token)

					local roll = token.properties:GetAttributeRoll(attrid)
					if string.find(roll, "disadvantage") then
						element:SetClass("disadvantage", true)
						element:SetClass("advantage", false)
					elseif string.find(roll, "advantage") then
						element:SetClass("disadvantage", false)
						element:SetClass("advantage", true)
					else
						element:SetClass("disadvantage", false)
						element:SetClass("advantage", false)
					end

					element.text = ModifierStr(token.properties:GetAttribute(attrid):Modifier())
				end,
			},

		}
	end

	local attrParentPanels = {
		gui.Panel{
			classes = {"rollsCollection"},
			children = leftAttr,
		},
		gui.Panel{
			classes = {"rollsCollection"},
			children = rightAttr,
		},
	}

	local attrParentPanel = gui.Panel{
		classes = {"rollsDoubleCollection"},
		halign = "center",
		children = attrParentPanels,
	}

	--SAVING THROWS
	leftAttr = {}
	rightAttr = {}
	attrPanels = leftAttr
	for i,saveid in ipairs(creature.savingThrowIds) do
		local saveInfo = creature.savingThrowInfo[saveid]
		local attrid = saveInfo.attrid
		local attrInfo = creature.attributesInfo[attrid]
		if i > #creature.attributeIds/2 then
			attrPanels = rightAttr
		end

		attrPanels[#attrPanels+1] = gui.Panel{
			classes = {"singleRollPanel"},
			bgimage = "panels/square.png",
			rightClick = function(element)
				token.properties:RollSavingThrow(saveid)
			end,
			press = function(element)
				token.properties:ShowSavingThrowRollDialog(saveid)
			end,
			gui.Label{
				classes = {"rollLabel"},
				interactable = false,
				text = saveInfo.description,
			},
			gui.Label{
				classes = {"rollValue"},
				interactable = false,
				refreshToken = function(element, token)

					if token == nil then
						return
					end

					local roll = token.properties:GetSavingThrowRoll(saveid)
					if string.find(roll, "disadvantage") then
						element:SetClass("disadvantage", true)
						element:SetClass("advantage", false)
					elseif string.find(roll, "advantage") then
						element:SetClass("disadvantage", false)
						element:SetClass("advantage", true)
					else
						element:SetClass("disadvantage", false)
						element:SetClass("advantage", false)
					end

					element.text = token.properties:SavingThrowModStr(saveid)
				end,
			},
		}
	end

	local saveParentPanels = {
		gui.Panel{
			classes = {"rollsCollection"},
			children = leftAttr,
		},
		gui.Panel{
			classes = {"rollsCollection"},
			children = rightAttr,
		},
	}

	local saveParentPanel = gui.Panel{
		classes = {"rollsDoubleCollection"},
		halign = "center",
		children = saveParentPanels,
	}

	--SKILL ROLLS
	local leftSkills = {}
	local rightSkills = {}

	local skillsPanels = leftSkills
	for i,skill in ipairs(Skill.SkillsInfo) do
		if i > #Skill.SkillsInfo/2 then
			skillsPanels = rightSkills
		end
		skillsPanels[#skillsPanels+1] = gui.Panel{
			classes = {"singleRollPanel"},
			bgimage = "panels/square.png",
			rightClick = function(element)
				token.properties:ShowSkillRollDialog(skill, {autoroll = true})
			end,
			press = function(element)
				token.properties:ShowSkillRollDialog(skill)
			end,
			gui.Label{
				classes = {"rollLabel"},
				interactable = false,
				text = skill.name,
			},
			gui.Label{
				classes = {"rollValue"},
				interactable = false,
				refreshToken = function(element, token)

					local roll = token.properties:GetSkillCheckRoll(skill)
					if string.find(roll, "disadvantage") then
						element:SetClass("disadvantage", true)
						element:SetClass("advantage", false)
					elseif string.find(roll, "advantage") then
						element:SetClass("disadvantage", false)
						element:SetClass("advantage", true)
					else
						element:SetClass("disadvantage", false)
						element:SetClass("advantage", false)
					end

					element.text = token.properties:SkillModStr(skill)
				end,
			},
		}
	end



	local skillsParentPanels = {
		gui.Panel{
			classes = {"rollsCollection"},
			children = leftSkills,
		},
		gui.Panel{
			classes = {"rollsCollection"},
			children = rightSkills,
		},
	}

	local skillsParentPanel = gui.Panel{
		classes = {"rollsDoubleCollection"},
		halign = "center",
		children = skillsParentPanels,
	}

	--Condition DC's
	local ongoingDCPanel = gui.Panel{
		classes = {"rollsDoubleCollection"},
		gui.Label{
			classes = {"rollLabel"},
			interactable = false,
			halign = "center",
			refreshToken = function(element, token)
				local ongoingEffects = token.properties:try_get("ongoingEffects")
				local text = ""
				if ongoingEffects ~= nil then
					for i,effect in ipairs(ongoingEffects) do
						if effect:try_get("ongoingDC", nil) ~= nil then
							local ongoingEffectsTable = dmhub.GetTable("characterOngoingEffects") or {}
							local nameInfo = ongoingEffectsTable[effect.ongoingEffectid].name
							text = string.format("%s%s: %s\n", text, nameInfo, effect.ongoingDC)
						end
					end
				end
				element.text = text
			end,
		},
		
	}

	local notesPanel = gui.Label{
		classes = {"notesLabel"},
		data = {
			charid = "",
			revision = "",
		},

		refreshToken = function(element, token)
			if token.charid == element.data.charid and token.properties:try_get("notesRevision", "") == element.data.revision then
				return
			end

			element.data.charid = token.charid
			element.data.revision = token.properties:try_get("notesRevision", "")

			local notesText = ""
			for _,entry in ipairs(token.properties:try_get("notes", {})) do
				if entry.title ~= nil and entry.title ~= "" and entry.text ~= nil and entry.text ~= "" then
					notesText = string.format("%s<b>%s</b>--%s\n\n", notesText, entry.title, entry.text)
				end
			end

			element.text = notesText
		end,
	}

	resultPanel = gui.Panel{
		classes = {"rollsPanel"},
		styles = RollsStyles,
		flow = "vertical",
		refreshToken = function(element, tok)
			--this updates the token member so that we update what clicking to roll does to use this token.
			token = tok
		end,

		gui.Panel{
			classes = {"rollsSection"},
			initiativePanel,
		},

		gui.Panel{
			classes = {"rollsSection"},
			attrParentPanel,
			gui.Label{
				classes = {"rollTitle"},
				text = GameSystem.AttributeNamePlural,
			},
		},

		gui.Panel{
			classes = {"rollsSection"},
			saveParentPanel,
			gui.Label{
				classes = {"rollTitle"},
				text = GameSystem.SavingThrowNamePlural,
			},
		},

		gui.Panel{
			classes = {"rollsSection"},
			skillsParentPanel,
			gui.Label{
				classes = {"rollTitle"},
				text = GameSystem.SkillNamePlural,
			},
		},

		gui.Panel {
			classes = { "rollsSection" },
			ongoingDCPanel,
			gui.Label {
				classes = { "rollTitle" },
				text = "CURRENT CONDITION DCS"
			},
			refreshToken = function(element, token)
				local ongoingEffects = token.properties:try_get("ongoingEffects")
				local ishidden = true
				if ongoingEffects ~= nil then
					for i,effect in ipairs(ongoingEffects) do
						if effect:try_get("ongoingDC", nil) ~= nil then
							ishidden = false
						end
					end
				end
				if ishidden then
					element:AddClass('collapsed')
				else
					element:RemoveClass('collapsed')
				end
			end
		},

		notesPanel,
	}

	return resultPanel
end
