--[[
    Ancestry detail / selectors
]]

local SELECTOR = "ancestry"
local INITIAL_CATEGORY = "overview"

local _fireControllerEvent = CharacterBuilder._fireControllerEvent
local _getController = CharacterBuilder._getController
local _getCreature = CharacterBuilder._getCreature
local _getData = CharacterBuilder._getData
local _getToken = CharacterBuilder._getToken

--- Placeholder for content in a center panel
function CharacterBuilder._ancestryDetail()
    local ancestryPanel

    local function makeCategoryButton(options)
        options.height = 48
        options.width = 250
        options.valign = "top"
        options.bmargin = 16
        options.bgcolor = CharacterBuilder.COLORS.BLACK03
        options.borderColor = CharacterBuilder.COLORS.GRAY02
        if options.click == nil then
            options.click = function(element)
                ancestryPanel:FireEventTree("categoryChange", element.data.category)
            end
        end
        if options.categoryChange == nil then
            options.categoryChange = function(element, newCategory)
                element:FireEvent("setSelected", newCategory == element.data.category)
            end
        end
        if options.refreshBuilderState == nil then
            options.refreshBuilderState = function(element, state)
                element:FireEvent("setAvailable", state:Get("ancestry.selectedId") ~= nil)
            end
        end
        return gui.SelectorButton(options)
    end

    local overview = makeCategoryButton{
        text = "Overview",
        data = { category = INITIAL_CATEGORY },
    }
    local lore = makeCategoryButton{
        text = "Lore",
        data = { category = "lore" },
    }
    local features = makeCategoryButton{
        text = "Features",
        data = { category = "features" },
    }
    local traits = makeCategoryButton{
        text = "Traits",
        data = { category = "traits" },
    }
    local change = makeCategoryButton{
        text = "Change Ancestry",
        data = { category = "change" },
        refreshToken = function(element)
            local creature = _getCreature(element)
            if creature then
                element:FireEvent("setAvailable", creature:try_get("raceid") ~= nil)
            end
        end,
        click = function(element)
            local creature = _getCreature(element)
            if creature then
                local controller = _getController(element)
                if controller then
                    creature.raceid = nil
                    creature.subraceid = nil
                    controller:FireEvent("tokenDataChanged")
                end
            end
        end,
        categoryChange = function() end,
        refreshBuilderState = function(element)
            element:FireEvent("refreshToken")
        end,
    }

    local categoryNavPanel = gui.Panel{
        classes = {"categoryNavPanel", "panel-base", "builder-base"},
        width = CharacterBuilder.SIZES.BUTTON_PANEL_WIDTH + 20,
        height = "99%",
        valign = "top",
        vpad = CharacterBuilder.SIZES.ACTION_BUTTON_HEIGHT,
        flow = "vertical",
        vscroll = true,
        borderColor = "teal",

        data = {
            category = INITIAL_CATEGORY,
        },

        create = function(element)
            element:FireEventTree("categoryChange", element.data.category)
        end,

        categoryChange = function(element, newCategory)
            element.data.catgory = newCategory
        end,

        refreshBuilderState = function(element)
            dmhub.Schedule(0.1, function()
                element:FireEventTree("categoryChange", element.data.category)
            end)
        end,

        overview,
        lore,
        features,
        traits,
        change,
    }

    local ancestryOverviewPanel = gui.Panel{
        id = "ancestryOverviewPanel",
        classes = {"ancestryOverviewPanel", "bordered", "panel-base", "builder-base", "collapsed"},
        width = "96%",
        height = "99%",
        valign = "center",
        halign = "center",
        bgcolor = "white",

        data = {
            category = "overview",
        },

        categoryChange = function(element, currentCategory)
            element:SetClass("collapsed", currentCategory ~= element.data.category)
        end,

        refreshBuilderState = function(element, state)
            element:FireEvent("categoryChange", element.data.category)
            local ancestryId = state:Get("ancestry.selectedId")
            if ancestryId == nil then
                -- element.bgcolor = "#667788"
                -- element.bgimage = true
                return
            end
            local race = dmhub.GetTable(Race.tableName)[ancestryId]
            element.bgimage = race.portraitid
        end,

        gui.Panel{
            width = "100%-2",
            height = "auto",
            valign = "bottom",
            vmargin = 32,
            flow = "vertical",
            bgimage = true,
            vpad = 8,
            gui.Label{
                classes = {"builder-base", "label", "label-info", "label-header"},
                width = "100%",
                height = "auto",
                hpad = 12,
                bgimage = true,
                bgcolor = "#333333cc",
                text = "ANCESTRY",
                textAlignment = "left",
                refreshBuilderState = function(element, state)
                    local ancestryId = state:Get("ancestry.selectedId")
                    if ancestryId then
                        local race = dmhub.GetTable(Race.tableName)[ancestryId]
                        element.text = race.name
                    end
                end
            },
            gui.Label{
                classes = {"builder-base", "label", "label-info"},
                width = "100%",
                height = "auto",
                hpad = 12,
                bmargin = 12,
                bold = false,
                fontSize = 18,
                textAlignment = "left",
                bgimage = true,
                bgcolor = "#333333cc",
                text = CharacterBuilder.STRINGS.ANCESTRY.INTRO,
            },
            gui.Label{
                classes = {"builder-base", "label", "label-info"},
                width = "100%",
                height = "auto",
                hpad = 12,
                tmargin = 12,
                bold = false,
                fontSize = 18,
                textAlignment = "left",
                bgimage = true,
                bgcolor = "#333333cc",
                text = CharacterBuilder.STRINGS.ANCESTRY.OVERVIEW,
            }
        }
    }

    local ancestryDetailPanel = gui.Panel{
        id = "ancestryDetailPanel",
        classes = {"builder-base", "panel-base", "ancestryDetailpanel"},
        width = 660,
        height = "99%",
        valign = "center",
        halign = "center",
        borderColor = "teal",

        ancestryOverviewPanel,
    }

    ancestryPanel = gui.Panel{
        id = "ancestryPanel",
        classes = {"builder-base", "panel-base", "ancestryPanel"},
        width = "100%",
        height = "100%",
        flow = "horizontal",
        valign = "center",
        halign = "center",
        borderColor = "yellow",
        data = {
            selector = "ancestry",
        },

        refreshBuilderState = function(element, state)
            local visible = state:Get("activeSelector") == element.data.selector
            element:SetClass("collapsed", not visible)
        end,

        categoryNavPanel,
        ancestryDetailPanel,
    }

    return ancestryPanel
end
