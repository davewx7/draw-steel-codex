local mod = dmhub.GetModLoading()

RegisterGameType("Race")

local defaultRace = nil

Race.tableName = "races"
Race.height = 6
Race.weight = ""
Race.lifeSpan = ""
Race.size = "Medium"
Race.moveSpeeds = {
	walk = 30,
}

--portrait used in previews of the race.
Race.portraitid = ""

Race.name = "New Ancestry"
Race.subrace = false
Race.details = ""
Race.lore = ""

Race._tmp_domains = false

function Race.CreateNew()
	return Race.new{
	}
end

function Race:Describe()
	return self.name
end

function Race:Domain()
	return string.format("race:%s", self.id)
end

function Race:EnsureDomain()
	if self._tmp_domains then
		return
	end

	self._tmp_domains = true
	local domain = self:Domain()
	self:GetClassLevel():SetDomain(domain)

	for _,level in ipairs(self:try_get("levels") or {}) do
		level:SetDomain(domain)
	end
end

function Race:IsInherited()
    local formerLifeFeature = self and self:GetClassLevel() and self:GetClassLevel().features[1]
    if formerLifeFeature == nil or formerLifeFeature.typeName ~= 'CharacterAncestryInheritanceChoice' then
        return false
    end

    return formerLifeFeature
end

function Race:ForceDomains(domains)
	return
end

function Race:FillClassFeatures(characterLevel, choices, result)
	if result == nil then
		printf("ERROR:: %s", traceback())
	end
	self:EnsureDomain()
	for i,feature in ipairs(self:GetClassLevel().features) do
		if feature.typeName == 'CharacterFeature' then
			result[#result+1] = feature
		else
			feature:FillChoice(choices, result)
		end
	end

	for levelNum,level in ipairs(self:try_get("levels") or {}) do
		if characterLevel ~= nil and levelNum > characterLevel then
			break
		end
		
		for i,feature in ipairs(level.features) do
			if feature.typeName == 'CharacterFeature' then
				result[#result+1] = feature
			else
				feature:FillChoice(choices, result)
			end
		end
	end
end

--result is filled with a list of { race = Race object, feature = CharacterFeature or CharacterChoice }
function Race:FillFeatureDetails(characterLevel, choices, result)
	self:EnsureDomain()

	for i,feature in ipairs(self:GetClassLevel().features) do
		local resultFeatures = {}
		feature:FillFeaturesRecursive(choices, resultFeatures)

		for i,resultFeature in ipairs(resultFeatures) do
			result[#result+1] = {
				race = self,
				feature = resultFeature,
			}
		end
	end
	
	for levelNum,level in ipairs(self:try_get("levels") or {}) do
		if characterLevel ~= nil and levelNum > characterLevel then
			break
		end

		for i,feature in ipairs(level.features) do
			local resultFeatures = {}
			feature:FillFeaturesRecursive(choices, resultFeatures)

			for i,resultFeature in ipairs(resultFeatures) do
				result[#result+1] = {
					race = self,
					feature = resultFeature,
				}
			end
		end
	end
end

function Race:FeatureSourceName()
	return string.format("%s Race Feature", self.name)
end

--this is where a race stores its modifiers etc, which are very similar to what a class gets.
function Race:GetClassLevel()
	if self:try_get("modifierInfo") == nil then
		self.modifierInfo = ClassLevel:CreateNew()
	end

	return self.modifierInfo
end

function Race.DefaultRace()
	if defaultRace == nil then

		local racesTable = dmhub.GetTable('races') or {}
		for k,v in pairs(racesTable) do
			if defaultRace == nil or v.name == 'Human' then
				defaultRace = k
			end
		end
	end
	return defaultRace
end

function Race.GetDropdownList()
	local result = {}
	local racesTable = dmhub.GetTable('races')
	for k,v in pairs(racesTable) do
		result[#result+1] = { id = k, text = v.name }
		dmhub.Debug('DEFAULT RACE DROPDOWN: ' .. k .. ' -> ' .. v.name)
	end
	table.sort(result, function(a,b)
		return a.text < b.text
	end)
	return result
end

function Race:GetLevel(levelNum)

    local key = string.format("level-%d", levelNum)

	local table = self:get_or_add("levels", {})
	if table[key] == nil then
		table[key] = ClassLevel.CreateNew()
		table[key]:SetDomain(self:Domain())
	end

	return table[key]
end