--[[
    Main panel of the Character Builder
    ... plus some other WIP that will eventually move out
]]

--- Placeholder for content in a center panel
function CharacterBuilder._ancestryPanel(detailPanel)
    local ancestryPanel

    local function makeCategoryButton(options)
        options.valign = "top"
        options.bmargin = 16
        options.width = CharacterBuilder.SIZES.ACTION_BUTTON_WIDTH
        return gui.SelectorButton(options)
    end

    local overview = makeCategoryButton{
        text = "Overview",
        data = { selector = "overview" },
        click = function(element)
        end,
    }
    local lore = makeCategoryButton{
        text = "Lore",
        data = { selector = "lore" },
        click = function(element)
        end,
    }
    local features = makeCategoryButton{
        text = "Features",
        data = { selector = "features" },
        click = function(element)
        end,
    }
    local traits = makeCategoryButton{
        text = "Traits",
        data = { selector = "traits" },
        click = function(element)
        end,
    }
    local change = makeCategoryButton{
        text = "Change Ancestry",
        data = { selector = "change" },
        click = function(element)
        end,
    }

    local selectorsPanel = gui.Panel{
        classes = {"selectorsPanel", "panel-base", "builder-base"},
        width = CharacterBuilder.SIZES.BUTTON_PANEL_WIDTH,
        height = "99%",
        valign = "top",
        vpad = CharacterBuilder.SIZES.ACTION_BUTTON_HEIGHT,
        flow = "vertical",
        vscroll = true,
        borderColor = "teal",
        data = {
            openPanel = "",
        },

        selectorClick = function(element, selector)
            if element.data.openPanel ~= selector then
                element.data.openPanel = selector
                ancestryPanel.FireEvent("selectorChange", selector)
            end
        end,

        overview,
        lore,
        features,
        traits,
        change,
    }

    local ancestryOverviewPanel = gui.Panel{
        id = "ancestryOverviewPanel",
        classes = {"ancestryOverviewPanel", "bordered", "panel-base", "builder-base"},
        width = "96%",
        height = "99%",
        valign = "center",
        halign = "center",
        bgcolor = "#667788",

        gui.Panel{
            width = "100%-2",
            height = "auto",
            valign = "bottom",
            vmargin = 32,
            flow = "vertical",
            bgimage = true,
            bgcolor = "#333333cc",
            vpad = 8,
            gui.Label{
                classes = {"builder-base"},
                width = "100%",
                height = "auto",
                hpad = 12,
                fontSize = 40,
                text = "ANCESTRY",
                textAlignment = "left",
            },
            gui.Label{
                classes = {"label", "builder-base"},
                width = "100%",
                height = "auto",
                hpad = 12,
                bold = false,
                fontSize = 18,
                textAlignment = "left",
                text = CharacterBuilder.STRINGS.ANCESTRY.OVERVIEW,
            }
        }
    }

    local ancestryDetailPanel = gui.Panel{
        id = "ancestryDetailPanel",
        classes = {"ancestryDetailpanel", "panel-base", "builder-base"},
        width = "80%-" .. CharacterBuilder.SIZES.BUTTON_PANEL_WIDTH,
        height = "99%",
        valign = "center",
        halign = "center",
        borderColor = "teal",

        ancestryOverviewPanel,
    }

    ancestryPanel = gui.Panel{
        id = "ancestryPanel",
        classes = {"ancestryPanel", "panel-base", "builder-base"},
        width = "100%",
        height = "100%",
        flow = "horizontal",
        valign = "center",
        halign = "center",
        borderColor = "yellow",

        selectorChange = function(element, newSelector)
        end,

        selectorsPanel,
        ancestryDetailPanel,
    }

    return ancestryPanel
end

--- Minimal implementation for the center panel. Non-reactive.
function CharacterBuilder._detailPanel(builderPanel)
    local detailPanel

    local ancestryPanel = CharacterBuilder._ancestryPanel(detailPanel)

    detailPanel = gui.Panel{
        id = "detailPanel",
        classes = {"detailPanel", "panel-base", "builder-base"},
        width = CharacterBuilder.SIZES.CENTER_PANEL_WIDTH,
        height = "99%",
        valign = "center",
        borderColor = "blue",

        ancestryPanel,
    }

    return detailPanel
end

-- Minimal implementation for the character panel. Non-reactive.
function CharacterBuilder._characterPanel(builderPanel)

    local characterPanel

    local popoutAvatar = gui.Panel {
        classes = { "hidden" },
        interactable = false,
        width = 800,
        height = 800,
        halign = "center",
        valign = "center",
        bgcolor = "white",
    }

    local avatar = gui.IconEditor {
        library = cond(dmhub.GetSettingValue("popoutavatars"), "popoutavatars", "Avatar"),
        restrictImageType = "Avatar",
        allowPaste = true,
        borderColor = Styles.textColor,
        borderWidth = 2,
        cornerRadius = 75,
        width = 150,
        height = 150,
        autosizeimage = true,
        halign = "center",
        valign = "top",
        tmargin = 20,
        bgcolor = "white",

        children = { popoutAvatar, },

        thinkTime = 0.2,
        think = function(element)
            element:FireEvent("imageLoaded")
        end,

        updatePopout = function(element, ispopout)
            if not ispopout then
                popoutAvatar:SetClass("hidden", true)
            else
                popoutAvatar:SetClass("hidden", false)
                popoutAvatar.bgimage = element.value
                popoutAvatar.selfStyle.scale = .25
                element.bgimage = false --"panels/square.png"
            end

            local parent = element:FindParentWithClass("avatarSelectionParent")
            if parent ~= nil then
                parent:SetClassTree("popout", ispopout)
            end
        end,

        imageLoaded = function(element)
            if element.bgsprite == nil then
                return
            end

            local maxDim = max(element.bgsprite.dimensions.x, element.bgsprite.dimensions.y)
            if maxDim > 0 then
                local yratio = element.bgsprite.dimensions.x / maxDim
                local xratio = element.bgsprite.dimensions.y / maxDim
                element.selfStyle.imageRect = { x1 = 0, y1 = 1 - yratio, x2 = xratio, y2 = 1 }
            end
        end,

        refreshAppearance = function(element, info)
            print("APPEARANCE:: Set avatar", info.token.portrait)
            element.SetValue(element, info.token.portrait, false)
            element:FireEvent("imageLoaded")
            element:FireEvent("updatePopout", info.token.popoutPortrait)
        end,
        change = function(element)
            -- local info = CharacterSheet.instance.data.info
            -- info.token.portrait = element.value
            -- info.token:UploadAppearance()
            -- CharacterSheet.instance:FireEvent("refreshAll")
            -- element:FireEvent("imageLoaded")
        end,
    }

    local characterName = gui.Label {
        classes = {"label", "builder-base"},
        text = "calculating...",
        width = "98%",
        height = "auto",
        halign = "center",
        valign = "top",
        textAlignment = "center",
        tmargin = 12,
        fontSize = 24,
        editable = true,
        data = {
            inCharSheet = false,
        },
        create = function(element)
            element.data.inCharSheet = CharacterBuilder._inCharSheet(element) and CharacterSheet.instance and CharacterSheet.instance.data and CharacterSheet.instance.data.info and CharacterSheet.instance.data.info.token
            if element.data.inCharSheet then
                element.text = CharacterSheet.instance.data.info.token.name or "Unnamed Character"
            end
        end,
        change = function(element)
            if element.data.inCharSheet then
                if element.text ~= CharacterSheet.instance.data.info.token.name then
                    CharacterSheet.instance.data.info.token.name = element.text
                    CharacterSheet.instance:FireEventTree("refreshToken", CharacterSheet.instance.data.info)
                end
            end
        end,
    }

    characterPanel = gui.Panel{
        id = "characterPanel",
        classes = {"characterPanel", "bordered", "panel-base", "builder-base"},
        width = CharacterBuilder.SIZES.CHARACTER_PANEL_WIDTH,
        height = "99%",
        valign = "center",
        -- halign = "right",
        flow = "vertical",

        avatar,
        characterName,
    }

    return characterPanel
end

--- Create the main panel for the builder.
--- Supports being placed inside the CharacterSheet as a tab
--- or as a stand-alone dialog.
--- In the CharacterSheet, it will instantly update the token.
--- @return Panel
function CharacterBuilder.CreatePanel()

    local builderPanel

    local selectorsPanel = CharacterBuilder._selectorsPanel(builderPanel)
    local detailPanel = CharacterBuilder._detailPanel(builderPanel)
    local characterPanel = CharacterBuilder._characterPanel(builderPanel)

    builderPanel = gui.Panel{
        id = "builderPanel",
        styles = CharacterBuilder._getStyles(),
        classes = {"builderPanel", "panel-base", "builder-base"},
        width = "99%",
        height = "99%",
        halign = "center",
        valign = "center",
        flow = "horizontal",
        borderColor = "red",

        selectorChange = function(element, newSelector)
        end,

        selectorsPanel,
        detailPanel,
        characterPanel,
    }

    return builderPanel
end

-- TODO: Remove the gate on dev mode
if devmode() then

--- Our tab in the character sheet
CharSheet.RegisterTab {
    id = "builder2",
    text = "Builder (WIP)",
	visible = function(c)
		return c ~= nil and c:IsHero()
	end,
    panel = CharacterBuilder.CreatePanel
}
dmhub.RefreshCharacterSheet()

end
