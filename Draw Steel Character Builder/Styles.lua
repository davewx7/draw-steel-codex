--- Styles for Character Builder

local DEBUG_PANEL_BG = false

CharacterBuilder.COLORS = {
    BLACK = "#000000",
    CREAM = "#BC9B7B",
    GOLD = "#966D4B",
    GRAY2 = "#666663",
    PANEL_BG = "#080B09",
}

CharacterBuilder.SIZES = {
    ACTION_BUTTON_WIDTH = 225,
    ACTION_BUTTON_HEIGHT = 45,
    BUTTON_SPACING = 12,
}
CharacterBuilder.SIZES.BUTTON_PANEL_WIDTH = CharacterBuilder.SIZES.ACTION_BUTTON_WIDTH + 60
CharacterBuilder.SIZES.CHARACTER_PANEL_WIDTH = math.floor(1.4 * CharacterBuilder.SIZES.BUTTON_PANEL_WIDTH)
CharacterBuilder.SIZES.CENTER_PANEL_WIDTH = "100%-" .. (30 + CharacterBuilder.SIZES.BUTTON_PANEL_WIDTH + CharacterBuilder.SIZES.CHARACTER_PANEL_WIDTH)

--[[
    Styles
]]

function CharacterBuilder._baseStyles()
    return {
        {
            selectors = {"builder-base"},
            fontSize = 14,
            fontFace = "Newzald",
            color = Styles.textColor,
            bold = false,
        },
        {
            selectors = {"font-black", "builder-base"},
            color = "#000000",
        },
    }
end

function CharacterBuilder._panelStyles()
    return {
        {
            selectors = {"panel-base", "builder-base"},
            height = "auto",
            width = "auto",
            pad = 2,
            margin = 2,
            bgimage = DEBUG_PANEL_BG and "panels/square.png",
            borderWidth = 1,
            border = DEBUG_PANEL_BG and 1 or 0
        },
        {
            selectors = {"bordered", "panel-base", "builder-base"},
            bgimage = true,
            borderColor = CharacterBuilder.COLORS.CREAM,
            border = 2,
            cornerRadius = 10,
        },
        {
            selectors = {"builderPanel", "panel-base", "builder-base"},
            bgcolor = CharacterBuilder.COLORS.PANEL_BG,
        }
    }
end

function CharacterBuilder._labelStyles()
    return {
        {
            selectors = {"label", "builder-base"},
            textAlignment = "center",
            fontSize = 14,
            color = Styles.textColor,
            bold = false,
        },
    }
end

function CharacterBuilder._buttonStyles()
    return {
        {
            selectors = {"button", "builder-base"},
            border = 1,
            borderWidth = 1,
        },
        {
            selectors = {"category", "button", "builder-base"},
            width = CharacterBuilder.SIZES.ACTION_BUTTON_WIDTH,
            height = CharacterBuilder.SIZES.ACTION_BUTTON_HEIGHT,
            halign = "center",
            valign = "top",
            bmargin = 20,
            fontSize = 24,
            cornerRadius = 5,
            textAlignment = "left",
        },
        {
            selectors = {"available", "button", "builder-base"},
            borderColor = CharacterBuilder.COLORS.CREAM,
            color = CharacterBuilder.COLORS.GOLD,
        },
        {
            selectors = {"unavailable", "button", "builder-base"},
            borderColor = CharacterBuilder.COLORS.GRAY2,
            color = CharacterBuilder.COLORS.GRAY2,
        }
    }
end

function CharacterBuilder._inputStyles()
    return {
        {
            selectors = {"text-entry", "builder-base"},
            bgcolor = "#191A18",
            borderColor = "#666663",
        },
        {
            selectors = {"primary", "text-entry", "builder-base"},
            height = 48,
        },
        {
            selectors = {"secondary", "text-entry", "builder-base"},
            height = 36,
        },
    }
end

function CharacterBuilder._getStyles()
    local styles = {}

    local function mergeStyles(sourceStyles)
        for _, style in ipairs(sourceStyles) do
            styles[#styles + 1] = style
        end
    end

    mergeStyles(CharacterBuilder._baseStyles())
    mergeStyles(CharacterBuilder._panelStyles())
    mergeStyles(CharacterBuilder._labelStyles())
    mergeStyles(CharacterBuilder._buttonStyles())
    mergeStyles(CharacterBuilder._inputStyles())

    return styles
end