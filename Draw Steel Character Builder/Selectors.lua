--[[
    Selectors - managing the left side of the builder
]]

function CharacterBuilder._createDetailedSelectorPanel(config)
    local selectorPanel
    local buttons = {}

    for _,item in ipairs(config.items) do
        buttons[#buttons+1] = gui.SelectorButton{
            valign = "top",
            tmargin = CharacterBuilder.SIZES.BUTTON_SPACING,
            text = item.name,
            data = { id = item.id },
            available = true,
            create = function(element)
                if CharacterBuilder._inCharSheet(element) then
                    local creature = CharacterSheet.instance.data.info.token.properties
                    local selected = config.getSelected(creature)
                    if selected then
                        element:FireEvent("setSelected", selected.id == element.data.id)
                    end
                end
            end,
            click = function(element)
                print("THC:: VALUES::", json(element.value))
                print("THC:: " .. string.upper(config.selectorName) .. ":: CLICK::", element.data.id, element.value or "nope")
            end,
        }
    end

    selectorPanel = gui.Panel {
        classes = {"collapsed"},
        width = "90%",
        height = "auto",
        valign = "top",
        halign = "right",
        flow = "vertical",
        data = { selector = config.selectorName },
        selectorChange = function(element, selector)
            print(string.format("THC:: SELPANEL:: %s:: %s SELCHANGE:: %s",
                string.upper(config.selectorName), element.data.selector, selector))
            element:SetClass("collapsed", selector ~= element.data.selector)
        end,
        children = buttons,
    }

    return selectorPanel
end

function CharacterBuilder._ancestrySelectorPanel()
    return CharacterBuilder._createDetailedSelectorPanel{
        items = CharacterBuilder._sortItemsByName(CharacterBuilder._toArray(dmhub.GetTableVisible(Race.tableName))),
        selectorName = "ancestry",
        getSelected = function(creature) return creature:Race() end,
    }
end

function CharacterBuilder._careerSelectorPanel()
    return CharacterBuilder._createDetailedSelectorPanel{
        items = CharacterBuilder._sortItemsByName(CharacterBuilder._toArray(dmhub.GetTableVisible(Background.tableName))),
        selectorName = "career",
        getSelected = function(creature) return creature:Background() end,
    }
end

function CharacterBuilder._classSelectorPanel()
    return CharacterBuilder._createDetailedSelectorPanel{
        items = CharacterBuilder._sortItemsByName(CharacterBuilder._toArray(dmhub.GetTableVisible(Class.tableName))),
        selectorName = "class",
        getSelected = function(creature) return creature:GetClass() end,
    }
end

function CharacterBuilder._cultureSelectorPanel()
    local cultureCats = dmhub.DeepCopy(CultureAspect.categories)
    for _,item in ipairs(cultureCats) do
        item.name = item.text
    end
    return CharacterBuilder._createDetailedSelectorPanel{
        items = CharacterBuilder._sortItemsByName(cultureCats),
        selectorName = "culture",
        getSelected = function(creature) return nil end,
    }
end

function CharacterBuilder._selectorsPanel()

    local selectors = {}
    for _,selector in ipairs(CharacterBuilder.Selectors) do
        selectors[#selectors+1] = selector.selector()
    end

    local selectorsPanel = gui.Panel{
        classes = {"selectorsPanel", "panel-base", "builder-base"},
        width = CharacterBuilder.SIZES.BUTTON_PANEL_WIDTH,
        height = "99%",
        halign = "left",
        valign = "top",
        flow = "vertical",
        vscroll = true,
        borderColor = "blue",
        data = {
            currentSelector = "",
        },

        selectorClick = function(element, selector)
            if element.data.currentSelector ~= selector then
                local builderPanel = element:FindParentWithClass("builderPanel")
                if builderPanel then
                    builderPanel:FireEventTree("selectorChange", selector)
                end
                element.data.currentSelector = selector
            end
        end,

        children = selectors,
    }

    return selectorsPanel
end

function CharacterBuilder._makeSelectorButton(options)
    options.valign = "top"
    options.tmargin = CharacterBuilder.SIZES.BUTTON_SPACING
    options.available = true
    if options.click == nil then
        options.click = function(element)
            local selectorsPanel = element:FindParentWithClass("selectorsPanel")
            if selectorsPanel then
                selectorsPanel:FireEvent("selectorClick", element.data.selector)
            end
        end
    end
    if options.selectorChange == nil then
        options.selectorChange = function(element, selector)
            element:FireEvent("setSelected", selector == element.data.selector)
        end
    end
    return gui.ActionButton(options)
end

function CharacterBuilder._createDetailedSelector(config)
    local selectorButton = CharacterBuilder._makeSelectorButton{
        text = config.text,
        data = { selector = config.selectorName },
        selectorChange = function(element, selector)
            local selfSelected = selector == element.data.selector
            local parentPane = element:FindParentWithClass(config.selectorName .. "-selector")
            if parentPane then
                element:FireEvent("setSelected", selfSelected)
                parentPane:FireEvent("showDetail", selfSelected)
            end
        end,
    }

    local selector = gui.Panel{
        classes = {config.selectorName .. "-selector"},
        width = "100%",
        height = "auto",
        pad = 0,
        margin = 0,
        flow = "vertical",
        data = { detailPane = nil },

        showDetail = function(element, show)
            if show then
                if not element.data.detailPane then
                    element.data.detailPane = config.createDetailPanel()
                    element:AddChild(element.data.detailPane)
                end
            end
            if element.data.detailPane then
                element.data.detailPane:SetClass("collapsed", not show)
            end
        end,

        children = {
            selectorButton
        },
    }

    return selector
end

function CharacterBuilder._backSelector()
    return CharacterBuilder._makeSelectorButton{
        text = "BACK",
        data = { selector = "back" },
        create = function(element)
            element:SetClass("collapsed", CharacterBuilder._inCharSheet(element))
        end,
        click = function(element)
            print("THC:: TODO:: Not in CharSheet. Close the window, probably?")
        end,
    }
end

function CharacterBuilder._characterSelector()
    return CharacterBuilder._makeSelectorButton{
        text = "Character",
        data = { selector = "character" },
    }
end

function CharacterBuilder._ancestrySelector()
    return CharacterBuilder._createDetailedSelector{
        text = "Ancestry",
        selectorName = "ancestry",
        createDetailPanel = CharacterBuilder._ancestrySelectorPanel,
    }
end

function CharacterBuilder._cultureSelector()
    return CharacterBuilder._createDetailedSelector{
        text = "Culture",
        selectorName = "culture",
        createDetailPanel = CharacterBuilder._cultureSelectorPanel,
    }
end

function CharacterBuilder._careerSelector()
    return CharacterBuilder._createDetailedSelector{
        text = "Career",
        selectorName = "career",
        createDetailPanel = CharacterBuilder._careerSelectorPanel,
    }
end

function CharacterBuilder._classSelector()
    return CharacterBuilder._createDetailedSelector{
        text = "Class",
        selectorName = "class",
        createDetailPanel = CharacterBuilder._classSelectorPanel,
    }
end

function CharacterBuilder._kitSelector()
    return CharacterBuilder._makeSelectorButton{
        text = "Kit",
        data = { selector = "kit" },
    }
end

function CharacterBuilder._complicationSelector()
    return CharacterBuilder._makeSelectorButton{
        text = "Complication",
        data = { selector = "complication" },
    }
end

CharacterBuilder.RegisterSelector{
    id = "back",
    ord = 1,
    selector = CharacterBuilder._backSelector
}

CharacterBuilder.RegisterSelector{
    id = "character",
    ord = 2,
    selector = CharacterBuilder._characterSelector
}

CharacterBuilder.RegisterSelector{
    id = "ancestry",
    ord = 3,
    selector = CharacterBuilder._ancestrySelector
}

CharacterBuilder.RegisterSelector{
    id = "culture",
    ord = 4,
    selector = CharacterBuilder._cultureSelector
}

CharacterBuilder.RegisterSelector{
    id = "career",
    ord = 5,
    selector = CharacterBuilder._careerSelector
}

CharacterBuilder.RegisterSelector{
    id = "class",
    ord = 6,
    selector = CharacterBuilder._classSelector
}

CharacterBuilder.RegisterSelector{
    id = "kit",
    ord = 7,
    selector = CharacterBuilder._kitSelector
}

CharacterBuilder.RegisterSelector{
    id = "complication",
    ord = 8,
    selector = CharacterBuilder._complicationSelector
}
