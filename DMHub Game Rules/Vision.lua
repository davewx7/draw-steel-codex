local mod = dmhub.GetModLoading()

RegisterGameType("VisionType")

VisionType.tableName = "VisionType"
VisionType.name = "Vision"
VisionType.type = "none"
VisionType.penetrateWalls = false
VisionType.fieldOfView = false
VisionType.defaultValue = 0
VisionType.hidden = false
VisionType.alwaysShowOnCharacterSheet = false

--this populates the CustomAttributes list with vision attributes.
function VisionType.PopulateAttributes(list)
    local t = dmhub.GetTable(VisionType.tableName) or {}

    for k,v in pairs(t) do
        list[#list+1] = {
            id = k,
            text = v.name,
            attributeType = "number",
            category = "Senses",
        }
    end
end

VisionType.availableTypes = {
    {
        id = "none",
        text = "None",
    },
    {
        id = "normal",
        text = "Normal",
    },
    {
        id = "dark",
        text = "Darkvision",
    }
}

function VisionType.CreateNew(args)
    local options = {
        id = dmhub.GenerateGuid(),
    }

    for k,v in pairs(args or {}) do
        options[k] = v
    end

    return VisionType.new(options)
end

function VisionType.CreateEditor()
    local resultPanel

    local m_vision = nil

    local Upload = function()
        dmhub.SetAndUploadTableItem(VisionType.tableName, m_vision)
    end

    resultPanel = gui.Panel{
        classes = {"hidden"},
        flow = "vertical",
        width = 1000,
        height = "auto",

        data = {
            SetData = function(id)
                local t = dmhub.GetTable(VisionType.tableName) or {}
                local vision = t[id]
                if vision ~= nil then
                    m_vision = vision
                    resultPanel:FireEventTree("vision")
                    resultPanel:SetClass("hidden", false)
                else
                    resultPanel:SetClass("hidden", true)
                end
            end,
        },

        styles = {
            Compendium.Styles,
            {
                classes = {"formLabel"},
                minWidth = 100,
                valign = "center",
            },

        },

        gui.Panel{
            classes = {"formPanel"},
            gui.Label{
                classes = {"formLabel"},
                text = "Name:",
            },
            gui.Input{
                text = "",
                characterLimit = 24,
                vision = function(element)
                    element.text = m_vision.name
                end,
                change = function(element)
                    m_vision.name = element.text
                    Upload()
                end,
            }
        },

        gui.Panel{
            classes = {"formPanel"},
            gui.Label{
                classes = {"formLabel"},
                text = "Vision:",
            },
            gui.Dropdown{
                options = VisionType.availableTypes,
                vision = function(element)
                    element.idChosen = m_vision.type
                end,
                change = function(element)
                    m_vision.type = element.idChosen
                    Upload()
                end,
            }
        },

        gui.Check{
            text = "Penetrates Solid",

            vision = function(element)
                element.value = m_vision.penetrateWalls
            end,
            change = function(element)
                m_vision.penetrateWalls = element.value
                Upload()
            end,
        },

        gui.Check{
            text = "Respect Field of View",

            vision = function(element)
                element.value = m_vision.fieldOfView
            end,
            change = function(element)
                m_vision.fieldOfView = element.value
                Upload()
            end,
        },

        gui.Check{
            text = "Always Show on Character Sheet",

            vision = function(element)
                element.value = m_vision.alwaysShowOnCharacterSheet
            end,
            change = function(element)
                m_vision.alwaysShowOnCharacterSheet = element.value
                Upload()
            end,
        },

    }

    return resultPanel
end