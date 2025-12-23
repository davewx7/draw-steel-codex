--[[
    Selector panels
]]

CBFeatureSelector = RegisterGameType("CBFeatureSelector")

local _fireControllerEvent = CharacterBuilder._fireControllerEvent
local _getCreature = CharacterBuilder._getCreature

--- Build a feature panel with selections
--- @return Panel|nil
function CBFeatureSelector.Panel(feature)
    -- print("THC:: FEATUREPANEL::", feature)
    -- print("THC:: FEATUREPANEL::", json(feature))

    local typeName = feature.typeName or ""
    if typeName == "CharacterDeityChoice" then
    elseif typeName == "CharacterFeatChoice" then
    elseif typeName == "CharacterFeatureChoice" then
    elseif typeName == "CharacterLanguageChoice" then
    elseif typeName == "CharacterSkillChoice" then
        return CBFeatureSelector.SkillPanel(feature)
    elseif typeName == "CharacterSubclassChoice" then
    end

    return nil
end

--- Render a skill choice panel
--- @param feature CharacterSkillChoice
--- @return Panel|nil
function CBFeatureSelector.SkillPanel(feature)

    local candidateSkills = {}
    local categories = feature:try_get("categories", {})
    local individual = feature:try_get("individual", {})
    if (categories and next(categories)) or (individual and next(individual)) then
        local skills = dmhub.GetTableVisible(Skill.tableName)
        for key,item in pairs(skills) do
            if (individual and individual[key]) or (categories and categories[item.category]) then
                candidateSkills[#candidateSkills+1] = item
            end
        end
        table.sort(candidateSkills, function(a,b) return a.name < b.name end)
    else
        candidateSkills = Skill.skillsDropdownOptions
    end

    -- Selection targets
    local targets = {}
    local numChoices = feature:NumChoices(creature)
    for i = 1, numChoices do
        targets[#targets+1] = gui.Label{
            classes = {"builder-base", "label", "choice-selection", "empty"},
            text = "Empty Slot",
            data = {
                featureGuid = feature.guid,
                itemIndex = i,
                selectedItem = nil,
            },
            click = function(element)
                _fireControllerEvent(element, "deleteSkill", {
                    levelChoiceGuid = element.data.featureGuid,
                    itemIndex = element.data.itemIndex,
                    selectedId = element.data.selectedItem.id,
                })
            end,
            linger = function(element)
                if element.data.selectedId then
                    gui.Tooltip("Press to delete")(element)
                end
            end,
            refreshBuilderState = function(element, state)
                element.data.selectedItem = nil
                element.text = "Empty Slot"
                local creature = _getCreature(state)
                if creature then
                    local levelChoices = creature:GetLevelChoices()
                    if levelChoices then
                        local selectedItems = levelChoices[element.data.featureGuid]
                        if selectedItems and #selectedItems >= element.data.itemIndex then
                            local selectedId = selectedItems[element.data.itemIndex]
                            if selectedId then
                                local skillItem = dmhub.GetTableVisible(Skill.tableName)[selectedId]
                                if skillItem then
                                    element.data.selectedItem = skillItem
                                    element.text = skillItem.name
                                end
                            end
                        end
                    end
                end
                element:SetClass("filled", element.data.selectedItem ~= nil)
                element:SetClass("empty", element.data.selectedItem == nil)
            end,
        }
    end

    -- Candidate items
    local options = {}
    for _,item in ipairs(candidateSkills) do
        options[#options+1] = gui.Label{
            classes = {"builder-base", "label", "choice-option"},
            valign = "top",
            text = item.name,
            data = {
                id = item.id,
                item = item,
            },
            click = function(element)
                local parent = element:FindParentWithClass("featureSelector")
                if parent then
                    parent:FireEvent("selectItem", element.data.item.id)
                end
            end,
            refreshBuilderState = function(element, state)
                local creature = _getCreature(state)
                if creature then
                    element:SetClass("collapsed", creature:ProficientInSkill(element.data.item))
                end
            end,
            refreshSelection = function(element, selectedId)
                element:SetClass("selected", selectedId == element.data.item.id)
            end,
        }
    end

    return CBFeatureSelector._mainPanel(feature, targets, options)
end

--- Build a consistent list of targets and children
--- @param feature table
--- @param targets table The targets for the selections
--- @param options table The options from which to select
--- @return table children
function CBFeatureSelector._buildChildren(feature, targets, options)
    local children = {}

    children[#children+1] = gui.Label {
        classes = {"builder-base", "label", "label-feature-name"},
        text = feature.name,
    }

    children[#children+1] = gui.Label {
        classes = {"builder-base", "label", "label-feature-desc"},
        text = feature:GetDescription(),
    }

    children = table.append_arrays(children, targets)

    children[#children+1] = gui.MCDMDivider{
        classes = {"builder-divider"},
        layout = "v",
        width = "96%",
        vpad = 4,
        bgcolor = CharacterBuilder.COLORS.GOLD,
    }

    children = table.append_arrays(children, options)

    return children
end

--- Build a consistent main panel
--- @param feature table
--- @param targets table The targets for the selections
--- @param options table The options from which to select
--- @return Panel
function CBFeatureSelector._mainPanel(feature, targets, options)

    local children = CBFeatureSelector._buildChildren(feature, targets, options)

    local scrollPanel = CBFeatureSelector._scrollPanel(children)

    local selectButton = CharacterBuilder._selectButton{
        click = function(element)
            local parent = element:FindParentWithClass("featureSelector")
            if parent then
                parent:FireEvent("applyCurrentItem")
            end
        end,
        refreshBuilderState = function(element, state)
            -- TODO:
        end,
    }

    return gui.Panel{
        classes = {"featureSelector", "builder-base", "panel"},
        width = "100%",
        height = "100%",
        halign = "left",
        flow = "vertical",

        data = {
            feature = feature,
            selectedId = nil,
        },

        applyCurrentItem = function(element)
            if element.data.selectedId then
                _fireControllerEvent(element, "applyLevelChoice", {
                    feature = feature,
                    selectedId = element.data.selectedId
                })
            end
        end,

        selectItem = function(element, itemId)
            element.data.selectedId = itemId
            element:FireEventTree("refreshSelection", itemId)
        end,

        scrollPanel,
        gui.MCDMDivider{
            classes = {"builder-divider"},
            layout = "line",
            width = "96%",
            vpad = 4,
            bgcolor = "white"
        },
        selectButton,
    }
end

--- Build a consistent scrollable panel for choices
--- @param children table The list of child elements to scroll
--- @return Panel
function CBFeatureSelector._scrollPanel(children)
    return gui.Panel {
        classes = {"builder-base", "panel"},
        width = "100%",
        height = "100%-60",
        halign = "left",
        valign = "top",
        flow = "vertical",
        vscroll = true,
        gui.Panel{
            classes = {"builder-base", "panel"},
            width = "100%",
            height = "auto",
            halign = "left",
            valign = "top",
            flow = "vertical",
            children = children,
        },
    }
end