local mod = dmhub.GetModLoading()

RegisterGameType("Background")

Background.tableName = "careers"

Background.name = "New Career"
Background.description = ""
Background.portraitid = ""

function Background.CreateNew()
	return Background.new{
	}
end

function Background:Describe()
	return self.name
end

function Background:FillClassFeatures(choices, result)
	for i,feature in ipairs(self:GetClassLevel().features) do

		if feature.typeName == 'CharacterFeature' then
			result[#result+1] = feature
		else
			feature:FillChoice(choices, result)
		end
	end
end

--result is filled with a list of { background = Background object, feature = CharacterFeature or CharacterChoice }
function Background:FillFeatureDetails(choices, result)
	for i,feature in ipairs(self:GetClassLevel().features) do
		local resultFeatures = {}
		feature:FillFeaturesRecursive(choices, resultFeatures)

		for i,resultFeature in ipairs(resultFeatures) do
			result[#result+1] = {
				background = self,
				feature = resultFeature,
			}
		end
	end
	
end

function Background:FeatureSourceName()
	return string.format("%s Career Feature", self.name)
end

--this is where a background stores its modifiers etc, which are very similar to what a class gets.
function Background:GetClassLevel()
	if self:try_get("modifierInfo") == nil then
		self.modifierInfo = ClassLevel:CreateNew()
	end

	return self.modifierInfo
end

function Background.GetDropdownList()
	local result = {
		{
			id = 'none',
			text = 'Choose...',
		}
	}
	local backgroundsTable = dmhub.GetTable(Background.tableName)
	for k,v in pairs(backgroundsTable) do
		result[#result+1] = { id = k, text = v.name }
	end
	table.sort(result, function(a,b)
		return a.text < b.text
	end)
	return result
end


local SetBackground = function(tableName, backgroundPanel, backgroundid)
	local backgroundTable = dmhub.GetTable(tableName) or {}
	local background = backgroundTable[backgroundid]
	local UploadBackground = function()
		dmhub.SetAndUploadTableItem(tableName, background)
	end

	local children = {}

	children[#children+1] = gui.Panel{
		flow = "vertical",
		width = 196,
		height = "auto",
		floating = true,
		halign = "right",
		valign = "top",
		gui.IconEditor{
		value = background.portraitid,
		library = "Avatar",
			width = "100%",
		height = "150% width",
		autosizeimage = true,
		allowPaste = true,
		borderColor = Styles.textColor,
		borderWidth = 2,
		change = function(element)
			background.portraitid = element.value
			UploadBackground()
		end,
		},

		gui.Label{
			text = "1000x1500 image",
			width = "auto",
			height = "auto",
			halign = "center",
			color = Styles.textColor,
			fontSize = 12,
		}
	}


	--the name of the background.
	children[#children+1] = gui.Panel{
		classes = {'formPanel'},
		gui.Label{
			text = 'Name:',
			valign = 'center',
			minWidth = 240,
		},
		gui.Input{
			text = background.name,
			change = function(element)
				background.name = element.text
				UploadBackground()
			end,
		},
	}

	children[#children+1] = gui.Input{
		fontSize = 14,
		vmargin = 4,
		width = 600,
		minHeight = 30,
		height = 'auto',
		multiline = true,
		text = background.description,
		textAlignment = "topleft",
		placeholderText = "Enter career description...",
		change = function(element)
			background.description = element.text
		end,
	}

	BackgroundCharacteristic.EmbedEditor(background, children, function()
		backgroundPanel:FireEvent("change")
		UploadBackground()
	end)

	children[#children+1] = background:GetClassLevel():CreateEditor(background, 0, {
		width = 800,
		change = function(element)
			backgroundPanel:FireEvent("change")
			UploadBackground()
		end,
	})
	backgroundPanel.children = children
end

function Background.CreateEditor()
	local backgroundPanel
	backgroundPanel = gui.Panel{
		data = {
			SetBackground = function(tableName, backgroundid)
				SetBackground(tableName, backgroundPanel, backgroundid)
			end,
		},
		vscroll = true,
		classes = 'class-panel',
		styles = {
			{
				halign = "left",
			},
			{
				classes = {'class-panel'},
				width = 1200,
				height = '90%',
				halign = 'left',
				flow = 'vertical',
				pad = 20,
			},
			{
				classes = {'label'},
				color = 'white',
				fontSize = 22,
				width = 'auto',
				height = 'auto',
			},
			{
				classes = {'input'},
				width = 200,
				height = 26,
				fontSize = 18,
				color = 'white',
			},
			{
				classes = {'formPanel'},
				flow = 'horizontal',
				width = 'auto',
				height = 'auto',
				halign = 'left',
				vmargin = 2,
			},

		},
	}

	return backgroundPanel
end

