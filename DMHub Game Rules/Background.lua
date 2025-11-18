local mod = dmhub.GetModLoading()

RegisterGameType("Background")

Background.tableName = "backgrounds"

Background.name = "New Background"
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
	return string.format("%s Background Feature", self.name)
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
