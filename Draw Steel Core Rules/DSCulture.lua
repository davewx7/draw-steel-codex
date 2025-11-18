local mod = dmhub.GetModLoading()

RegisterGameType("Culture")

Culture.name = "Culture"
Culture.description = ""

Culture.languageid = ""
Culture.init = true

function Culture.CreateNew()
    local aspects = {}
    for i,cat in ipairs(CultureAspect.categories) do
        aspects[cat.id] = ""
    end
    local result = Culture.new{
        aspects = aspects,
    }

    return result
end

function Culture:Describe()
    return "Culture"
end

local cultureLanguageChoice = CharacterLanguageChoice.Create{
    guid = "cultureLanguageChoice",
    name = "Cultural Language",
    description = "Choose the language of your culture.",
}

local cultureLoreBenefit = nil
dmhub.RegisterEventHandler("refreshTables", function(keys)
    if cultureLoreBenefit == nil then
        cultureLoreBenefit = dmhub.DeepCopy(MCDMImporter.GetStandardFeature("Culture Lore Benefit"))
        if cultureLoreBenefit ~= nil then
            cultureLoreBenefit.description = "You gain an edge on tests made to recall lore about your culture, and on tests made to influence and interact with people of your culture."
        end
    end
end)

function Culture:FillFeatureDetails(choices, result)
    local langFeatures = {}
    cultureLanguageChoice:FillFeaturesRecursive(choices, langFeatures)
    for _,f in ipairs(langFeatures) do
        result[#result+1] = {
            culture = self,
            feature = f,
        }
    end

    if cultureLoreBenefit ~= nil then
        result[#result+1] = {
            culture = self,
            feature = cultureLoreBenefit,
        }
    end

    local t = dmhub.GetTable(CultureAspect.tableName)
    for k,v in pairs(self.aspects) do
        if v ~= "" then
            local entry = t[v]
            if entry ~= nil then
                entry:FillFeatureDetails(choices, result)
            end
        end
    end
end

function Culture:FillClassFeatures(choices, result)
    cultureLanguageChoice:FillChoice(choices, result)
    if cultureLoreBenefit ~= nil then
        cultureLoreBenefit:FillChoice(choices, result)
    end
    local t = dmhub.GetTable(CultureAspect.tableName)
    for k,v in pairs(self.aspects) do
        if v ~= "" then
            local entry = t[v]
            if entry ~= nil then
                entry:FillClassFeatures(choices, result)
            end
        end
    end
end

creature.culture = Culture.CreateNew()
creature.culture.init = false


function creature:GetCulture()
    return self.culture
end