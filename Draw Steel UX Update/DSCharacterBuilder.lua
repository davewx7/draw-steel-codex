local mod = dmhub.GetModLoading()

--our master reference of characterFeatures
--a list of { class/race/background = Class/Race/Background, levels = {list of ints}, feature = CharacterFeature or CharacterChoice }
local g_characterFeatures

--a dict of choiceid -> feat this choice was made for. This is useful to block unique choices.
local g_choicesMade

local g_levelChoices

local g_creature

-- Define colors based on Kelsey's swatches in the components figma
-- https://www.figma.com/design/7w8B3fjUaz9YX6GxS00Un6/Design-System---TEMP-IMPORT?node-id=1-352&t=IL2AX1ioJlm2LJTL-1

SwatchWhite     = "#FFFFFF"
SwatchLight     = "#E8E8E8"
SwatchNeutral1  = "#ABABAB"
SwatchNeutral2  = "#6F6F6F"
SwatchBlack     = "#000000"

SwatchCnB       = "#231F20"

local DSCharacterBuilder = {}

-- Define Font Styles based on the components figma
local BuilderStyles = {
    {
        selectors = {"FontNumbers"},
        fontSize = 16,
        fontFace = "Berling",
        fontWeight = "SemiBold",
        color = SwatchBlack,
        width = "auto",
        height = "auto",
    },
    {
        selectors = {"Header1"},
        fontSize = 12,
        fontFace = "Berling",
        fontWeight = "SemiBold",
        color = SwatchBlack,
        width = "auto",
        height = "auto",
    },
    {
        selectors = {"Header2"},
        fontSize = 8,
        fontFace = "Berling",
        fontWeight = "SemiBold",
        uppercase = true,
        color = SwatchBlack,
        width = "auto",
        height = "auto",
    },
    {
        selectors = {"Subheader"},
        fontSize = 6,
        fontFace = "Berling",
        fontWeight = "Regular",
        uppercase = true,
        color = SwatchBlack,
        width = "auto",
        height = "auto",
    },
    {
        selectors = {"SubheaderBold"},
        fontSize = 6,
        fontFace = "Berling",
        fontWeight = "SemiBold",
        uppercase = true,
        color = SwatchBlack,
        width = "auto",
        height = "auto",
    },    
    {
        selectors = {"Body"},
        fontSize = 8,
        fontFace = "Berling",
        fontWeight = "Regular",
        color = SwatchBlack,
        width = "auto",
        height = "auto",
    },     
    {
        selectors = {"BodyBold"},
        fontSize = 8,
        fontFace = "Berling",
        fontWeight = "SemiBold",
        color = SwatchBlack,
        width = "auto",
        height = "auto",
    },    
    {
        selectors = {"Details"},
        fontSize = 7,
        fontFace = "Berling",
        fontWeight = "Regular",
        color = SwatchBlack,
        width = "auto",
        height = "auto",
    },     
    {
        selectors = {"DetailsBold"},
        fontSize = 7,
        fontFace = "Berling",
        fontWeight = "SemiBold",
        color = SwatchBlack,
        width = "auto",
        height = "auto",
    },   
    {
        selectors = {"Annotation*"},
        fontSize = 6,
        fontFace = "Berling",
        fontWeight = "SemiBold",
        color = SwatchBlack,
        width = "auto",
        height = "auto",
    },      
}

function DSCharacterBuilder.MainSheet()

    local backgroundPanel = gui.Panel{
		styles = BuilderStyles,
        id = "UXTestPanel",
        halign = "left",
        valign = "top",
        width = 400,
        height = 400,
        bgcolor = SwatchLight,
        --bgcolor = "red",        
        bgimage = "panels/square.png",
        flow = "vertical",
        opacity = 0.9,
        interactable = false,

        gui.Label{
            classes = {"Header1"},
            text = "Welcome to the Character Builder Tab Contents",
            width = "auto"
        },
    }

    return backgroundPanel

end

--[[
CharSheet.RegisterTab{
    id = "DSBuilder",
    text = "DS Builder",
    panel = DSCharacterBuilder.MainSheet,
    order = 'zzz'
}
]]

dmhub.RefreshCharacterSheet()