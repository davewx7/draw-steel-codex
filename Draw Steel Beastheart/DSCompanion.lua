local mod = dmhub.GetModLoading()

RegisterGameType("AnimalCompanion", "monster")

creature.companionid = false

function creature:IsCompanion()
    return false
end

function AnimalCompanion:IsCompanion()
    return true
end

function AnimalCompanion:IsMonster()
    return false
end

function AnimalCompanion:RefreshToken(token)
    monster.RefreshToken(self, token)

    local summonerid = token.summonerid
    self._tmp_summonerid = summonerid

    local summonerToken = summonerid and dmhub.GetTokenById(self._tmp_summonerid)
    if summonerToken and summonerToken.valid then
        self._tmp_summonerToken = summonerToken
    else
        self._tmp_summonerToken = nil
    end
end

function AnimalCompanion:SummonerToken()
    if self:try_get("_tmp_summonerToken") and self._tmp_summonerToken.valid then
        return self._tmp_summonerToken
    end

    return nil
end

function AnimalCompanion:MaxHitpoints(modifiers)
    local summoner = self:SummonerToken()
    if not summoner then
        return 1
    end

    return summoner.properties:MaxHitpoints()
end

local g_companionSharedResources = {
    "5bd90f9b-46be-4cf2-8ca6-a96430d62949", --recovery
    "d19658a2-4d7b-4504-af9e-1a5410fb17fd", --main action
    "a513b9a6-f311-4b0f-88b8-4e9c7bf92d0b", --maneuver
    "8b0ae5fe-0eb3-45fa-9e6d-b9de68f5cc6d", --surges
    "2d3d5511-4b80-46d1-a8c6-4705b9aa45ca", --heroic resources
    "2166c5fe-260e-4691-9743-06cf097a59f3", --hero tokens
}

local g_companionSharedResourcesKeyed = {}
for _,key in ipairs(g_companionSharedResources) do
    g_companionSharedResourcesKeyed[key] = true
end

function AnimalCompanion:GetResources()

    local cached = self:try_get("_tmp_companionresources")
    if cached ~= nil and self:try_get("_tmp_companionresourcesUpdate") == dmhub.ngameupdate then
        return cached
    end

    local result = table.shallow_copy(monster.GetResources(self))

    local summoner = self:SummonerToken()
    if summoner then
        local summonerResources = summoner.properties:GetResources()
        for _,key in ipairs(g_companionSharedResources) do
            result[key] = summonerResources[key]
        end
    end

    self._tmp_companionresources = result
    self._tmp_companionresourcesUpdate = dmhub.ngameupdate

    return result
end

function AnimalCompanion:GetHeroicOrMaliceResources()
    local summoner = self:SummonerToken()
    if summoner then
        return summoner.properties:GetHeroicOrMaliceResources()
    end

    return 0
end


function AnimalCompanion:ConsumeResource(key, refreshType, quantity, note)
    if g_companionSharedResourcesKeyed[key] then
        local summoner = self:SummonerToken()
        if summoner then
            print("RESOURCE:: CONSUME ON SUMMONER", quantity)
            summoner:ModifyProperties {
                description = "Consume Resource from Animal Companion",
                execute = function()
                    summoner.properties:ConsumeResource(key, refreshType, quantity, note)
                end,
            }
        end

        return
    end

    return monster.ConsumeResource(self, key, refreshType, quantity, note)
end


function AnimalCompanion:RefreshResource(key, refreshType, quantity, note)
            print("RESOURCE:: REFRESH...", quantity)
    if g_companionSharedResourcesKeyed[key] then
        local summoner = self:SummonerToken()
        if summoner then
            print("RESOURCE:: REFRESH ON SUMMONER", quantity)
            summoner:ModifyProperties {
                description = "Refresh Resource from Animal Companion",
                execute = function()
                    summoner.properties:RefreshResource(key, refreshType, quantity, note)
                end,
            }
        end

        return
    end

    monster.RefreshResource(self, key, refreshType, quantity, note)
end

function AnimalCompanion:AddUnboundedResource(key, quantity, note)
    if g_companionSharedResourcesKeyed[key] then
        local summoner = self:SummonerToken()
        if summoner then
            summoner:ModifyProperties {
                description = "Add Resource from Animal Companion",
                execute = function()
                    summoner.properties:AddUnboundedResource(key, quantity, note)
                end,
            }
        end

        return
    end

    return monster.AddUnboundedResource(self, key, quantity, note)
end

function AnimalCompanion:GetUnboundedResourceQuantity(resourceid)
    if g_companionSharedResourcesKeyed[resourceid] then
        local summoner = self:SummonerToken()
        if summoner then
            return summoner.properties:GetUnboundedResourceQuantity(resourceid)
        end

        return 0
    end

    return monster.GetUnboundedResourceQuantity(self, resourceid)
end

function AnimalCompanion:GetHeroicResourceName()
    local summoner = self:SummonerToken()
    if summoner then
        return summoner.properties:GetHeroicResourceName()
    end

    return "Ferocity"
end


function AnimalCompanion:GetHeroTokens()
    return character.GetHeroTokens(self)
end

function AnimalCompanion:GetActivatedAbilities(options)
	options = table.shallow_copy(options or {})
    options.excludeKeywords = {"Beastheart"}

    local result = {}

    local summoner = self:SummonerToken()
    if summoner then
        result = summoner.properties:GetActivatedAbilities(options)
    end

    local numDerivedAbilities = #result

    local ourAbilities = monster.GetActivatedAbilities(self, options)
    for i,ability in ipairs(ourAbilities) do
        local alreadyExists = false
        for j=1,numDerivedAbilities do
            if result[j].name == ability.name then
                alreadyExists = true
                break
            end
        end

        if not alreadyExists then
            result[#result+1] = ability
        end
    end

    return result
end

local g_rampageResourceId = "9f418676-96be-402b-92da-0f50294146b3"

local function CreateCharacterDisplayPanel(element)
    local m_token = nil


    element.data.resourcePanel = gui.Panel {
        width = "100%",
        height = "auto",
        flow = "horizontal",

        hover = function(element)
            local desc = "Rampage"
            local text = nil
            element.tooltip = gui.StatsHistoryTooltip{ text = text, description = desc, entries = m_token.properties:GetStatHistory(g_rampageResourceId):GetHistory() }
        end,


        gui.Label {
            width = "auto",
            height = "auto",
            halign = "left",
            fontSize = 16,
            color = Styles.textColor,
            text = "<b>Rampage</b>:",
        },
        gui.Label {
            editable = true,
            numeric = true,
            lmargin = 8,
            width = 40,
            characterLimit = 3,
            fontSize = 16,
            height = "auto",
            change = function(element)
                local quantity = tonumber(element.text) or 0
                if quantity < 0 then
                    quantity = 0
                end

                local currentQuantity = m_token.properties:GetUnboundedResourceQuantity(g_rampageResourceId)

                m_token:ModifyProperties {
                    description = "Set Rampage",
                    execute = function()
                        m_token.properties:AddUnboundedResource(g_rampageResourceId, quantity - currentQuantity, "Rampage")
                    end,
                }

                element:FireEvent("refreshCompanion", m_token)
            end,

            refreshCompanion = function(element, token)
                m_token = token

                local quantity = token.properties:GetUnboundedResourceQuantity(g_rampageResourceId)
                element.text = tostring(quantity)
            end,
        }
    }

    element:AddChild(element.data.resourcePanel)

end

local g_refreshGuid = dmhub.GenerateGuid()

function AnimalCompanion:DisplayCharacterPanel(token, element)
    local summoner = self:SummonerToken()
    if not summoner then
        element:SetClass("collapsed", true)
        return
    end

    print("DISPLAY:: CREATING")
    element:SetClass("collapsed", false)

    if element.data.init ~= g_refreshGuid then
        element.data.init = g_refreshGuid
        CreateCharacterDisplayPanel(element)
    end

    element:FireEventTree("refreshCompanion", token)

    return true
end

function creature:GetProgressionResource()
    return self:GetHeroicOrMaliceResources()
end

function creature:GetProgressionResourceHighWaterMark()
    return self:HeroicResourceHighWaterMarkForTurn()
end

function AnimalCompanion:GetProgressionResource()
    return self:GetUnboundedResourceQuantity(g_rampageResourceId)
end

function AnimalCompanion:GetProgressionResourceHighWaterMark()
    return self:GetProgressionResource()
end