--[[
    Class detail / selectors
]]
CBClassDetail = RegisterGameType("CBClassDetail")

local mod = dmhub.GetModLoading()

local SELECTOR = "class"
local INITIAL_CATEGORY = "overview"
local AVAILABLE_WITHOUT_CLASS = {overview = true}

local _fireControllerEvent = CharacterBuilder._fireControllerEvent
local _getHero = CharacterBuilder._getHero
local _makeDetailNavButton = CharacterBuilder._makeDetailNavButton

--- Generate the navigation panel
--- @return Panel
function CBClassDetail._navPanel()

    local overviewButton = _makeDetailNavButton(SELECTOR, {
        text = "Overview",
        data = { category = INITIAL_CATEGORY },
    })
    local changeButton = _makeDetailNavButton(SELECTOR, {
        classes = {"changeClass"},
        text = "Change Class",
        data = { category = "change" },
        click = function(element)
            _fireControllerEvent(element, "removeClass")
        end,
        refreshBuilderState = function(element, state)
            local hero = _getHero(state)
            if hero then
                local classes = hero:try_get("classes", {})
                element:FireEvent("setAvailable", #classes > 0)
            end
        end,
    })

    return gui.Panel{
        classes = {"categoryNavPanel", "builder-base", "panel-base", "detail-nav-panel"},
        vscroll = true,

        create = function(element)
            _fireControllerEvent(element, "updateState", {
                key = SELECTOR .. ".category.selectedId",
                value = INITIAL_CATEGORY,
            })
        end,

        registerFeatureButton = function(element, button)
            element:AddChild(button)
            local changeButton = element:FindChildRecursive(function(element) return element:HasClass("changeClass") end)
            if changeButton then changeButton:SetAsLastSibling() end
            element.children = CharacterBuilder._sortButtons(element.children)
        end,

        destroyFeature = function(element, featureId)
            local child = element:FindChildRecursive(function(e)
                return e.data and e.data.featureId == featureId
            end)
            if child then
                child:DestroySelf()
            end
        end,

        overviewButton,
        changeButton,
    }
end

--- Build the overview panel
--- Used when no Class is selected and to overview the selected class
--- @return Panel
function CBClassDetail._overviewPanel()

    local nameLabel = gui.Label{
        classes = {"builder-base", "label", "info", "header"},
        width = "100%",
        height = "auto",
        hpad = 12,
        text = "CLASS",
        textAlignment = "left",

        refreshBuilderState = function(element, state)
            local text = "CLASS"
            local classId = state:Get(SELECTOR .. ".selectedId")
            if classId then
                local class = state:Get(SELECTOR .. ".selectedItem")
                if not class then
                    class = dmhub.GetTable(Class.tableName)[classId]
                end
                if class then text = class.name end
            end
            element.text = text
        end
    }

    local introLabel = gui.Label{
        classes = {"builder-base", "label", "info"},
        width = "100%",
        height = "auto",
        vpad = 6,
        hpad = 12,
        bmargin = 12,
        textAlignment = "left",
        text = CharacterBuilder.STRINGS.CLASS.INTRO,

        refreshBuilderState = function(element, state)
            local text = CharacterBuilder.STRINGS.CLASS.INTRO
            local classId = state:Get(SELECTOR .. ".selectedId")
            if classId then
                local class = state:Get(SELECTOR .. ".selectedItem")
                if not class then
                    class = dmhub.GetTable(Class.tableName)[classId]
                end
                if class then text = CharacterBuilder._trimToLength(class.details, 300) end
            end
            element.text = text
        end,
    }

    local detailLabel = gui.Label{
        classes = {"builder-base", "label", "info"},
        width = "100%",
        height = "auto",
        vpad = 6,
        hpad = 12,
        tmargin = 12,
        textAlignment = "left",
        bold = false,
        text = CharacterBuilder.STRINGS.CLASS.OVERVIEW,

        refreshBuilderState = function(element, state)
            local text = CharacterBuilder.STRINGS.CLASS.OVERVIEW
            local classId = state:Get(SELECTOR .. ".selectedId")
            if classId then
                local textItems = {}

                local featureCache = state:Get(SELECTOR .. ".featureCache")
                local featureDetails = featureCache:GetFlattenedFeatures()
                for _,item in ipairs(featureDetails) do
                    local s = item.feature:GetSummaryText()
                    if s ~= nil and #s > 0 then
                        textItems[#textItems+1] = s
                    end
                end

                text = CharacterBuilder._trimToLength(table.concat(textItems, "\n\n"), 1800, false)
            end
            element.text = text
        end
    }

    return gui.Panel{
        id = "classOverviewPanel",
        classes = {"classOverviewPanel", "builder-base", "panel-base", "detail-overview-panel", "border", "collapsed"},
        bgimage = mod.images.classHome,

        data = {
            category = "overview",
        },

        refreshBuilderState = function(element, state)
            local classId = state:Get(SELECTOR .. ".selectedId")

            local visible = classId == nil or state:Get(SELECTOR .. ".category.selectedId") == element.data.category
            element:SetClass("collapsed", not visible)

            if visible then
                if classId == nil then
                    element.bgimage = mod.images.classHome
                    return
                end
                local class = state:Get(SELECTOR .. ".selectedItem")
                if not class then
                    class = dmhub.GetTable(Class.tableName)[classId]
                end
                if class then element.bgimage = class.portraitid end
            end
        end,

        gui.Panel{
            width = "100%-2",
            height = "auto",
            valign = "bottom",
            vmargin = 32,
            flow = "vertical",
            bgimage = true,
            vpad = 8,
            nameLabel,
            introLabel,
            detailLabel,
        }
    }
end

--- Build the Select button
--- @return PrettyButton|Panel
function CBClassDetail._selectButton()
    return CharacterBuilder._makeSelectButton{
        classes = {"selectButton"},
        click = function(element)
            _fireControllerEvent(element, "applyCurrentClass")
        end,
        refreshBuilderState = function(element, state)
            local hero = _getHero(state)
            if hero then
                local heroClass = hero:GetClass()
                local canSelect = heroClass == nil and state:Get(SELECTOR .. ".selectedId") ~= nil
                element:SetClass("collapsed", not canSelect)
            end
        end,
    }
end

--- Build the Detail Panel
--- @return Panel
function CBClassDetail.CreatePanel()

    local navPanel = CBClassDetail._navPanel()

    local overviewPanel = CBClassDetail._overviewPanel()

    local selectButton = CBClassDetail._selectButton()

    local detailPanel = gui.Panel{
        id = "classDetailPanel",
        classes = {"builder-base", "panel-base", "inner-detail-panel", "wide", "classDetailpanel"},

        registerFeaturePanel = function(element, panel)
            element:AddChild(panel)
            local selectButton = element:FindChildRecursive(function(e) return e:HasClass("selectButton") end)
            if selectButton then selectButton:SetAsLastSibling() end
        end,

        destroyFeature = function(element, featureId)
            local child = element:FindChildRecursive(function(e)
                return e.data and e.data.featureId == featureId
            end)
            if child then
                child:DestroySelf()
            end
        end,

        overviewPanel,
        selectButton,
    }

    return gui.Panel{
        id = "classPanel",
        classes = {"builder-base", "panel-base", "detail-panel", "classPanel"},
        data = {
            selector = SELECTOR,
            features = {},
        },

        refreshBuilderState = function(element, state)
            local visible = state:Get("activeSelector") == element.data.selector
            element:SetClass("collapsed", not visible)
            if not visible then
                element:HaltEventPropagation()
                return
            end

            local categoryKey = SELECTOR .. ".category.selectedId"
            local currentCategory = state:Get(categoryKey) or INITIAL_CATEGORY
            local hero = _getHero(state)
            if hero then
                local heroClass = hero:GetClass()

                if heroClass ~= nil then
                    for id,_ in pairs(element.data.features) do
                        element.data.features[id] = false
                    end

                    local featureCache = state:Get(SELECTOR .. ".featureCache")
                    local features = featureCache:GetSortedFeatures()
                    for _,f in ipairs(features) do
                        local featureId = f.guid
                        local feature = featureCache:GetFeature(featureId)
                        if feature then
                            if element.data.features[featureId] == nil then
                                local featureRegistry = CharacterBuilder._makeFeatureRegistry{
                                    feature = feature,
                                    selector = SELECTOR,
                                    selectedId = heroClass.id,
                                    getSelected = function(hero)
                                        local class = hero:GetClass()
                                        if class then return class.id end
                                    end
                                }
                                if featureRegistry then
                                    element.data.features[featureId] = true
                                    navPanel:FireEvent("registerFeatureButton", featureRegistry.button)
                                    detailPanel:FireEvent("registerFeaturePanel", featureRegistry.panel)
                                end
                            else
                                element.data.features[featureId] = true
                            end
                        end
                    end

                    for id, active in pairs(element.data.features) do
                        if active == false then
                            navPanel:FireEvent("destroyFeature", id)
                            detailPanel:FireEvent("destroyFeature", id)
                            element.data.features[id] = nil
                        end
                    end
                else
                    if not AVAILABLE_WITHOUT_CLASS[currentCategory] then
                        currentCategory = INITIAL_CATEGORY
                    end
                end
            end

            -- Which category to show?
            if not AVAILABLE_WITHOUT_CLASS[currentCategory] then
                if not element.data.features[currentCategory] then
                    currentCategory = INITIAL_CATEGORY
                end
            end
            state:Set{ key = categoryKey, value = currentCategory }
        end,

        navPanel,
        detailPanel,
    }
end
