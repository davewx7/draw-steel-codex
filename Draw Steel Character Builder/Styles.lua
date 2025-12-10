--- Styles for Character Builder

-- TODO: Clean up styles / ordering

--- Set this to true to draw layout helper borders around panels that have none
local DEBUG_PANEL_BG = false

CharacterBuilder.COLORS = {
    BLACK = "#000000",
    BLACK03 = "#191A18",
    CREAM = "#BC9B7B",
    CREAM03 = "#DFCFC0",
    GOLD = "#966D4B",
    GOLD03 = "#F1D3A5",
    GRAY02 = "#666663",
    PANEL_BG = "#080B09",
}

CharacterBuilder.SIZES = {
    -- Panels
    CHARACTER_PANEL_WIDTH = 447,
    AVATAR_DIAMETER = 185,

    -- Labels
    DESCRIPTION_LABEL_PAD = 4,

    -- Buttons
    ACTION_BUTTON_WIDTH = 225,
    ACTION_BUTTON_HEIGHT = 45,

    CATEGORY_BUTTON_WIDTH = 250,
    CATEGORY_BUTTON_HEIGHT = 48,
    CATEGORY_BUTTON_MARGIN = 16,

    SELECTOR_BUTTON_WIDTH = 200,
    SELECTOR_BUTTON_HEIGHT = 48,

    SELECT_BUTTON_WIDTH = 200,
    SELECT_BUTTON_HEIGHT = 36,

    BUTTON_SPACING = 12,

}
CharacterBuilder.SIZES.BUTTON_PANEL_WIDTH = CharacterBuilder.SIZES.ACTION_BUTTON_WIDTH + 60
CharacterBuilder.SIZES.CENTER_PANEL_WIDTH = "100%-" .. (30 + CharacterBuilder.SIZES.BUTTON_PANEL_WIDTH + CharacterBuilder.SIZES.CHARACTER_PANEL_WIDTH)

--[[
    Styles
]]

function CharacterBuilder._baseStyles()
    return {
        {
            selectors = {"builder-base"},
            fontSize = 14,
            fontFace = "Berling",
            color = Styles.textColor,
            bold = false,
        },
        {
            selectors = {"font-black"},
            color = "#000000",
        },
    }
end

function CharacterBuilder._panelStyles()
    return {
        {
            selectors = {"panel-base"},
            height = "auto",
            width = "auto",
            pad = 2,
            margin = 2,
            bgimage = DEBUG_PANEL_BG and "panels/square.png",
            borderWidth = 1,
            border = DEBUG_PANEL_BG and 1 or 0
        },
        {
            selectors = {"panel-border"},
            -- bgimage = true,
            -- bgcolor = "#ffffff",
            borderColor = CharacterBuilder.COLORS.CREAM,
            border = 2,
            cornerRadius = 10,
        },
        {
            selectors = {"builderPanel"},
            bgcolor = CharacterBuilder.COLORS.PANEL_BG,
        },
        {
            selectors = {CharacterBuilder.CONTROLLER_CLASS},
            bgcolor = "#ffffff",
            bgimage = true,
            gradient = gui.Gradient{
                type = "radial",
                point_a = {x = 0.5, y = 0.5},
                point_b = {x = 0.5, y = 1.0},
                stops = {
                    {position = -0.01, color = "#1c1c1c"},
                    {position = 0.00, color = "#1c1c1c"},
                    {position = 0.12, color = "#191919"},
                    {position = 0.25, color = "#161616"},
                    {position = 0.37, color = "#131413"},
                    {position = 0.50, color = "#101110"},
                    {position = 0.62, color = "#0d0f0d"},
                    {position = 0.75, color = "#0b0d0b"},
                    {position = 0.87, color = "#090c0a"},
                    {position = 1.00, color = "#080b09"},
                },
            },
        },
    }
end

function CharacterBuilder._labelStyles()
    return {
        {
            selectors = {"label"},
            textAlignment = "center",
            fontSize = 14,
            color = Styles.textColor,
            bold = false,
        },
        {
            selectors = {"label-info"},
            hpad = 12,
            fontSize = 18,
            textAlignment = "left",
            bgimage = true,
            bgcolor = "#10110FE5",
        },
        {
            selectors = {"label-header"},
            fontSize = 40,
            bold = true,
        },
        {
            selectors = {"description-label"},
            width = "50%",
            height = "auto",
            halign = "left",
            vpad = CharacterBuilder.SIZES.DESCRIPTION_LABEL_PAD,
            textAlignment = "left",
            fontSize = 18,
            bold = true,
        },
        {
            selectors = {"description-item"},
            width = "50%",
            height = "auto",
            halign = "left",
            vpad = CharacterBuilder.SIZES.DESCRIPTION_LABEL_PAD,
            textAlignment = "left",
            fontSize = 18,
        }
    }
end

function CharacterBuilder._buttonStyles()
    return {
        {
            selectors = {"button"},
            border = 1,
            borderWidth = 1,
        },
        {
            selectors = {"category"},
            width = CharacterBuilder.SIZES.ACTION_BUTTON_WIDTH,
            height = CharacterBuilder.SIZES.ACTION_BUTTON_HEIGHT,
            halign = "center",
            valign = "top",
            bmargin = 20,
            fontSize = 24,
            cornerRadius = 5,
            textAlignment = "left",
            bold = false,
        },
        {
            selectors = {"button-select"},
            width = CharacterBuilder.SIZES.SELECT_BUTTON_WIDTH,
            height = CharacterBuilder.SIZES.SELECT_BUTTON_HEIGHT,
            fontSize = 36,
            bold = true,
            cornerRadius = 5,
            border = 1,
            borderWidth = 1,
            borderColor = CharacterBuilder.COLORS.GOLD03,
            color = CharacterBuilder.COLORS.GOLD03,
        },
        {
            selectors = {"available"},
            borderColor = CharacterBuilder.COLORS.CREAM,
            color = CharacterBuilder.COLORS.GOLD,
        },
        {
            selectors = {"unavailable"},
            borderColor = CharacterBuilder.COLORS.GRAY02,
            color = CharacterBuilder.COLORS.GRAY02,
        }
    }
end

function CharacterBuilder._inputStyles()
    return {
        {
            selectors = {"text-entry"},
            bgcolor = "#191A18",
            borderColor = "#666663",
        },
        {
            selectors = {"primary"},
            height = 48,
        },
        {
            selectors = {"secondary"},
            height = 36,
        },
    }
end

function CharacterBuilder._characterPanelTabStyles()
    return {
        {
            selectors = {"char-tab-btn"},
            width = 24,
            height = 24,
            bgcolor = CharacterBuilder.COLORS.GOLD,
        },
        {
            selectors = {"char-tab-btn", "selected"},
            bgcolor = CharacterBuilder.COLORS.CREAM03,
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
    mergeStyles(CharacterBuilder._characterPanelTabStyles())

    return styles
end