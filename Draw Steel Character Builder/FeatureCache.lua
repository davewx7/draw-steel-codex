--[[
    A cache and wrappers for our features
    to support the builder
]]
local _safeGet = CharacterBuilder._safeGet

CBFeatureCache = RegisterGameType("CBFeatureCache")
CBFeatureCache.__index = CBFeatureCache

CBFeatureWrapper = RegisterGameType("CBFeatureWrapper")
CBFeatureWrapper.__index = CBFeatureWrapper

CBOptionWrapper = RegisterGameType("CBOptionWrapper")
CBOptionWrapper.__index = CBOptionWrapper

--[[
    Custom callback handlers by class / typeName.
    Use these when you need to do something more
    than or different from writing to levelChoices.
]]
local selectionHandlers = {
    CharacterIncidentChoice = {
        apply = function(hero, feature, option)
            hero:RemoveNotesForTable(feature:GetGuid())
            local noteItem = hero:GetOrAddNoteForTableRow(feature:GetGuid(), option:GetGuid())
            if noteItem then
                noteItem.title = feature:GetName()
                noteItem.text = option:GetRow().value:ToString()
            end
        end,
        remove = function(hero, feature, option)
            hero:RemoveNoteForTableRow(feature:GetGuid(), option:GetGuid())
        end,
    }
}

--[[
    Feature Cache
]]

--- Create a new feature cache
--- @param hero character The hero character
--- @param selectedId string GUID of the selected item
--- @param selectedName string Display name of the selected item
--- @param features table Array of feature details
--- @return CBFeatureCache
function CBFeatureCache:new(hero, selectedId, selectedName, features)
    local instance = setmetatable({}, self)

    instance.selectedId = selectedId
    instance.selectedName = selectedName

    CBFeatureCache._processFeatures(instance, hero, features)

    return instance
end

--- @return boolean
function CBFeatureCache:AllFeaturesComplete()
    return self:try_get("allFeaturesComplete", false)
end

--- @param guid string
--- @return CBFeatureWrapper|nil
function CBFeatureCache:GetFeature(guid)
    return self.keyed[guid]
end

--- @return table
function CBFeatureCache:GetFlattenedFeatures()
    return self.flattened
end

--- @return string key The key of the item selected on the hero
function CBFeatureCache:GetSelectedId()
    return self.selectedId
end

--- @return string name The name of the item selected on the hero
function CBFeatureCache:GetSelectedName()
    return self.selectedName
end

--- @return table
function CBFeatureCache:GetSortedFeatures()
    return self.sorted
end

--- @param guid string
--- @return boolean|nil isComplete Whether that specific feature is complete or nil if we don't know about the feature
function CBFeatureCache:IsFeatureComplete(guid)
    local feature = self:GetFeature(guid)
    if feature then return feature:IsComplete() end
    return nil
end

--- @param hero character
--- @param features table
--- @private
function CBFeatureCache:_processFeatures(hero, features)
    local sorted = {}
    local flattened = {}
    local keyed = {}

    local function passesPrereq(feature)
        local prereq = feature:try_get("prerequisites")
        if prereq and #prereq > 0 then
            for _,pre in ipairs(prereq) do
                if not pre:Met(hero) then return false end
            end
        end
        return true
    end

    local function addFeature(feature)
        if not passesPrereq(feature) then return end
        local cacheFeature = CBFeatureWrapper:new(hero, feature)
        if cacheFeature then
            local guid = cacheFeature:GetGuid()
            keyed[guid] = cacheFeature
            sorted[#sorted+1] = { guid = guid, order = cacheFeature:GetOrder() }
            if self.allFeaturesComplete then self.allFeaturesComplete = cacheFeature:IsComplete() end
        end
    end

    self.allFeaturesComplete = true

    for _,item in ipairs(features) do
        if item.features ~= nil then
            for _,feature in ipairs(item.features) do
                flattened[#flattened+1] = { feature = feature }
                addFeature(feature)
            end
        elseif item.feature ~= nil then
            addFeature(item.feature)
        end
    end

    table.sort(sorted, function(a,b) return a.order < b.order end)

    self.sorted = sorted
    self.keyed = keyed
    self.flattened = #flattened > 0 and flattened or features
end

--[[
    Feature Wrapper
]]

--- Create a new feature wrapper
--- @param hero character
--- @param feature CharacterChoice
--- @return CBFeatureWrapper|nil
function CBFeatureWrapper:new(hero, feature)
    if not feature.IsDerivedFrom("CharacterChoice") then return nil end

    local instance = setmetatable({}, self)

    instance.feature = feature
    instance.category = CBFeatureWrapper._deriveCategory(feature)
    local nameOrder, categoryOrder = CBFeatureWrapper._deriveOrder(instance, feature)
    instance.order = nameOrder
    instance.categoryOrder = categoryOrder
    instance.currentOptionId = nil

    CBFeatureWrapper.Update(instance, hero)

    return instance
end

--- Determine whether to allow the current selected option
--- in the UI to be added to the hero.
--- @return boolean
function CBFeatureWrapper:AllowCurrentSelection()

    local option = self:GetSelectedOption()
    if option == nil then return false end

    if self:AllowOverselect() then return true end

    local curVal = self:GetSelectedValue()

    return curVal + option:GetPointsCost() <= self:GetNumChoices()
end

--- Determine whether we'll let the user select items into
--- the hero while items are already selected
--- @return boolean
function CBFeatureWrapper:AllowOverselect()
    return self:GetNumChoices() == 1
end

--- @return boolean
function CBFeatureWrapper:CostsPoints()
    return self.feature:try_get("costsPoints", false)
end

--- @return number The number of slots available / unassigned on the hero
function CBFeatureWrapper:GetAvailableSlots()
    return math.max(0, self:GetNumChoices() - self:GetSelectedValue())
end

--- @return string
function CBFeatureWrapper:GetCategory()
    return self.category
end

function CBFeatureWrapper:GetCategoryOrder()
    return self:try_get("categoryOrder", "99-zzz")
end

--- @return CBOptionWrapper|nil
function CBFeatureWrapper:GetChoice(choiceId)
    return self:GetChoicesKeyed()[choiceId]
end

--- @return table
function CBFeatureWrapper:GetChoices()
    return self:try_get("choices", {})
end

--- @return table
function CBFeatureWrapper:GetChoicesKeyed()
    return self:try_get("choicesKeyed", {})
end

--- @return string
function CBFeatureWrapper:GetDescription()
    return self.feature:GetDescription()
end

--- Get the underlying feature
--- @return CharacterChoice
function CBFeatureWrapper:GetFeature()
    return self.feature
end

--- @return string
function CBFeatureWrapper:GetGuid()
    return self.feature.guid
end

--- Get the maximum number of target panels that should be visible
--- @return number
function CBFeatureWrapper:GetMaxVisibleTargets()
    return #self:GetSelected() + self:GetAvailableSlots()
end

--- @return string|nil
function CBFeatureWrapper:GetName()
    return self.feature:try_get("name", "Unnamed Feature")
end

--- @return number
function CBFeatureWrapper:GetNumChoices()
    return self:try_get("numChoices", 1)
end

--- @return CBOptionWrapper|nil
function CBFeatureWrapper:GetOption(optionId)
    return self:GetOptionsKeyed()[optionId]
end

--- Calculate a display name including point cost if present
--- @param option CBOptionWrapper
--- @return string
function CBFeatureWrapper:GetOptionDisplayName(option)
    local name = option:GetName()
    if self:CostsPoints() then
        if not name:lower():find(" points)") then
            local pointCost = string.format(" (%d Points)", option:GetPointsCost())
            name = string.format("%s%s", name, pointCost)
        end
    end
    return name
end

--- Get the options as an array
--- @return table
function CBFeatureWrapper:GetOptions()
    return self:try_get("options", {})
end

--- @return table
function CBFeatureWrapper:GetOptionsKeyed()
    return self:try_get("optionsKeyed", {})
end

--- @return string
function CBFeatureWrapper:GetOrder()
    return self:try_get("order", "99-zzz")
end

--- @return RollTableReference
function CBFeatureWrapper:GetRollTable()
    return self.feature.characteristic:GetRollTable()
end

--- Get the list of items selected on the hero.
--- This is from levelChoices.
--- @return table
function CBFeatureWrapper:GetSelected()
    return self:try_get("selected", {})
end

--- Get the list of item names selected on the
--- hero as a sorted array. This is derived from
--- levelChoices.
--- @return table
function CBFeatureWrapper:GetSelectedNames()
    return self:try_get("selectedNames", {})
end

--- Get the option object currently selected
--- in the UI.
--- @return CBOptionWrapper|nil
function CBFeatureWrapper:GetSelectedOption()
    local id = self:GetSelectedOptionId()
    if not id then return nil end
    return self:GetOption(id)
end

--- Get the GUID of the option object currently
--- selected in the UI.
--- @return string|nil
function CBFeatureWrapper:GetSelectedOptionId()
    return self:try_get("currentOptionId")
end

--- Get the number of points spent on this feature
--- on the hero.
--- @return number
function CBFeatureWrapper:GetSelectedValue()
    return self:try_get("selectedValue", 0)
end

--- @return boolean
function CBFeatureWrapper:HasRoll()
    return self:try_get("hasRoll", false)
end

--- @return boolean
function CBFeatureWrapper:IsComplete()
    return self:GetSelectedValue() >= self:GetNumChoices()
end

--- Callback to support custom setting
--- @param hero character
--- @param option CBOptionWrapper
function CBFeatureWrapper:OnApplySelection(hero, option)
    local handlers = selectionHandlers[self.feature.typeName]
    if handlers and handlers.apply then
        handlers.apply(hero, self, option)
    end
end

--- Callback to support custom unsetting
--- @param hero character
--- @param option CBOptionWrapper
function CBFeatureWrapper:OnRemoveSelection(hero, option)
    local handlers = selectionHandlers[self.feature.typeName]
    if handlers and handlers.remove then
        handlers.remove(hero, self, option)
    end
end

--- @return boolean Allowed - was the selection allowed
function CBFeatureWrapper:SetSelectedOption(optionId)
    local option = self:GetOption(optionId)
    if option ~= nil then
        self.currentOptionId = optionId
        return true
    end
    return false
end

--- Update cached state from current hero selections
--- TODO: Perf tuning: This could be called only when the feature is used.
--- @param hero character
function CBFeatureWrapper:Update(hero)
    local levelChoices = hero:GetLevelChoices()

    self.selected = levelChoices[self:GetGuid()] or {}
    self.numChoices = self.feature:NumChoices(hero)

    local options = {}
    local optionsKeyed = {}
    local featureOptions = self.feature:GetOptions(levelChoices, hero)
    for _,option in ipairs(featureOptions) do
        local wrappedOption = CBOptionWrapper:new(option)
        options[#options+1] = wrappedOption
        optionsKeyed[wrappedOption:GetGuid()] = wrappedOption
    end
    table.sort(options, function(a,b) return a:GetOrder() < b:GetOrder() end)
    self.options = options
    self.optionsKeyed = optionsKeyed

    local choices = {}
    local choicesKeyed = {}
    local featureChoices = self.feature:Choices(1, self.selected, hero) or {}
    for _,choice in ipairs(featureChoices) do
        local wrappedChoice = CBOptionWrapper:new(choice)
        choices[#choices+1] = wrappedChoice
        choicesKeyed[wrappedChoice:GetGuid()] = wrappedChoice
    end
    table.sort(choices, function(a,b) return a:GetOrder() < b:GetOrder() end)
    self.choices = choices
    self.choicesKeyed = choicesKeyed

    local pointsSpent = 0
    local selectedNames = {}
    for _,id in ipairs(self.selected) do
        if optionsKeyed[id] then
            pointsSpent = pointsSpent + optionsKeyed[id]:GetPointsCost()
            selectedNames[#selectedNames+1] = optionsKeyed[id]:GetName()
            optionsKeyed[id]:SetSelected(true)
        end
        if choicesKeyed[id] then
            choicesKeyed[id]:SetSelected(true)
        end
    end
    table.sort(selectedNames)
    self.selectedValue = pointsSpent
    self.selectedNames = selectedNames

    self.hasRoll = self.feature:try_get("characteristic") ~= nil
end

--- Derive a category name from a feature
--- @param feature CharacterChoice
--- @return string
function CBFeatureWrapper._deriveCategory(feature)
    local translations = {
        CharacterAncestryInheritanceChoice = "Inherited Ancestry",
        CharacterFeatChoice = "Perk",
    }
    local typeName = feature.typeName
    if translations[typeName] then return translations[typeName] end

    -- Try to parse intelligently from the class name
    local catName = typeName:match("Character(.+)Choice")
    return catName:sub(1,1).. catName:sub(2):gsub("(%u)", " %1")
end

--- Derive sort order from feature type
--- @param feature CharacterChoice
--- @return string nameOrder
--- @return string categoryOrder
function CBFeatureWrapper:_deriveOrder(feature)
    local typeOrder = {
        CharacterAncestryInheritanceChoice  = 1,
        CharacterDeityChoice                = 2,
        CharacterDomainChoice               = 3,
        CharacterSubclassChoice             = 4,
        CharacterFeatureChoice              = 5,
        CharacterSkillChoice                = 6,
        CharacterLanguageChoice             = 7,
        CharacterFeatChoice                 = 8,
        CharacterIncidentChoice             = 9,
    }

    local orderNum = typeOrder[feature.typeName] or 99
    local nameOrder = string.format("%02d-%s", orderNum, self:GetName())
    local catOrder = string.format("%02d-%s", orderNum, self:GetCategory())

    return nameOrder, catOrder
end

--[[
    Option Wrapper
]]

--- @param option table
--- @return CBOptionWrapper
function CBOptionWrapper:new(option)
    local instance = setmetatable({}, self)
    instance.option = option
    instance.isSelected = false
    return instance
end

--- @return string|nil
function CBOptionWrapper:GetDescription()
    return _safeGet(self.option, "description")
end

--- @return string
function CBOptionWrapper:GetGuid()
    return _safeGet(self.option, "guid", _safeGet(self.option, "id"))
end

--- @return string
function CBOptionWrapper:GetName()
    return _safeGet(self.option, "name", _safeGet(self.option, "text"))
end

--- @return string
function CBOptionWrapper:GetOrder()
    return self:GetName()
end

--- @return number
function CBOptionWrapper:GetPointsCost()
    return _safeGet(self.option, "pointsCost", 1)
end

--- @return string|nil
function CBOptionWrapper:GetRollRange()
    return _safeGet(self.option, "rollRange")
end

--- @return table
function CBOptionWrapper:GetRow()
    return self.option.row
end

--- Get whether this option is selected on the hero.
--- @return boolean
function CBOptionWrapper:GetSelected()
    return self:try_get("isSelected", false)
end

--- @return boolean
function CBOptionWrapper:GetUnique()
    -- TODO: Maybe the default should be false
    return _safeGet(self.option, "unique", true)
end

--- @return boolean
function CBOptionWrapper:HasCustomPanel()
    return _safeGet(self.option, "hasCustomPanel", false)
        and _safeGet(self.option, "panel", nil) ~= nil
end

--- @return function|nil
function CBOptionWrapper:Panel()
    return _safeGet(self.option, "panel", nil)
end

--- Set whether this option is selected on the hero.
function CBOptionWrapper:SetSelected(selected)
    self.isSelected = selected
end
