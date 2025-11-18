local mod = dmhub.GetModLoading()

function CharSheet.CultureChoicePanel(options)
    local resultPanel

    local leftPanel
    local rightPanel

    local m_aspectHovered = nil

    local GetSelectedCulture = function()
		local creature = CharacterSheet.instance.data.info.token.properties
        return creature:GetCulture()
    end

    local cultureAspectTable = dmhub.GetTable(CultureAspect.tableName)

    local descriptionContainer = gui.Panel{
        halign = "center",
        valign = "top",
        borderWidth = 2,
        borderColor = Styles.textColor,
        vmargin = 24,
        width = "100%",
        height = "100% available",
        bgimage = "panels/square.png",
        bgcolor = "clear",
        flow = "vertical",

        create = function(element)
            element:FireEventTree("refreshBuilder")
        end,

        gui.Panel{
            vscroll = true,
            height = "100%",
            width = "100%",

            styles = CharSheet.carouselDescriptionStyles,

            gui.Panel{
                width = "95%",
                height = "auto",
                halign = "center",
                flow = "vertical",
                vmargin = 32,

                gui.Label{
                    bold = false,
                    fontSize = 32,
                    valign = "top",
                    halign = "left",
                    height = 36,
                    width = "100%",
                    textAlignment = "left",
                    editable = true,
                    characterLimit = 40,

                    change = function(element)
                        local culture = GetSelectedCulture()
                        culture.name = element.text
                    end,
                    
                    refreshBuilder = function(element)
                        local culture = GetSelectedCulture()
                        element.text = culture.name
                    end,
                },

                gui.Panel{
                    classes = {"separator"},
                },

                CharSheet.FeatureDetailsPanel{
                    data = {
                        hide = false,
                        criteria = {culture = "*"},
                    },
                    alert = function(element)
                        element:FireEvent("showAlert")
                    end
                },


                gui.Panel{
                    classes = {"padding"},
                },

                gui.Panel{
                    width = "100%",
                    height = "auto",
                    flow = "vertical",
                    data = {
                        featureDetailsPanels = {}
                    },

                    refreshBuilder = function(element)
                        for k,detailsPanel in pairs(element.data.featureDetailsPanels) do
                            local culture = GetSelectedCulture()
                            local aspectInfo = cultureAspectTable[culture.aspects[k]]
                            if aspectInfo ~= nil then
                                detailsPanel.data.hide = false
                                detailsPanel.data.criteria = {[k] = aspectInfo}
                            else
                                detailsPanel.data.hide = true
                            end
                        end
                    end,


                    create = function(element)
                        local children = {}

                        for _,entry in ipairs(CultureAspect.categories) do
                            children[#children+1] = gui.Panel{
                                classes = {"collapsibleHeading"},
                                click = function(element)
                                    element:SetClassTree("collapseSet", not element:HasClass("collapseSet"))
                                    element:Get(entry.id .. "Overview"):SetClass("collapsed", element:HasClass("collapseSet"))
                                end,
                                gui.Label{
                                    classes = {"sectionTitle"},
                                    text = entry.text,
                                    refreshBuilder = function(element)
                                        local culture = GetSelectedCulture()
                                        if cultureAspectTable[culture.aspects[entry.id]] ~= nil then
                                            element.text = string.format("%s: %s", entry.text, cultureAspectTable[culture.aspects[entry.id]].name)
                                        else
                                            element.text = entry.text
                                        end
                                    end,
                                },
                                gui.CollapseArrow{
                                    halign = "right",
                                    valign = "center",
                                },
                            }

                            children[#children+1] = gui.Panel{ classes = {"separator"} }

                            children[#children+1] = gui.Label{
                                id = entry.id .. "Overview",
                                classes = {"featureDescription"},
                                width = "100%",
                                wrap = true,
                                height = "auto",
                                refreshBuilder = function(element)
                                    local culture = GetSelectedCulture()
                                    local aspectInfo = cultureAspectTable[culture.aspects[entry.id]]
                                    if aspectInfo ~= nil then
                                        element.text = aspectInfo.description
                                    else
                                        element.text = entry.description
                                    end
                                end,
                            }

                            element.data.featureDetailsPanels[entry.id] = CharSheet.FeatureDetailsPanel{
                                alert = function(element)
                                    element:FireEvent("showAlert")
                                end
                            }

                            children[#children+1] = element.data.featureDetailsPanels[entry.id]

                            children[#children+1] = gui.Panel{ classes = {"padding"} }
                        end

                        element.children = children
                    end,
                },
            },
        },
    }

    leftPanel = gui.Panel{
        width = "50%",
        height = "100%",
        halign = "center",
        flow = "vertical",

        styles = {
            {
                classes = {"careerPanel"},
                bgcolor = "clear",
                borderWidth = 2,
                borderColor = Styles.textColor,
            },
            {
                classes = {"haveselection", "selected"},
                brightness = 1.8,
            },
            {
                classes = {"haveselection", "~selected"},
                brightness = 0.5,
            },
            {
                selectors = {"careerPanel", "hover"},
                borderWidth = 4,
                bgcolor = "#ffffff22",
            },
            {
                selectors = {"careerLabel", "parent:haveselection", "~parent:selected"},
                opacity = 0.4,
            },
            {
                selectors = {"careerIcon"},
                saturation = 0.8,
            },
            {
                selectors = {"careerIcon", "parent:hover"},
                saturation = 1.0,
            },
        },

        create = function(element)

            local aspectPanels = {}

            local colors = { "#ff0000", "#00ff00", "#0000ff", "#ffff00", "#ff00ff", "#00ffff", "#ff7f00", "#7f00ff", "#00ff7f", "#7fff00", "#ff007f", "#007fff", "#7f7f00", "#7f007f", "#007f7f", "#ff3f3f", "#3fff3f", "#3f3fff", }
            local colorsIndex = 0

            for i,aspectEntry in ipairs(CultureAspect.categories) do

                local children = {}

                for k,aspect in pairs(cultureAspectTable) do
                    if aspect.category == aspectEntry.id then
                        colorsIndex = colorsIndex + 1
                        if colorsIndex > #colors then
                            colorsIndex = 1
                        end
                        local iconColor = colors[colorsIndex]

                        local panel = gui.Panel{
                            data = {
                                ord = aspect.name,
                            },
                            classes = {"careerPanel"},
                            flow = "horizontal",
                            width = "28%",
                            hmargin = 20,
                            vmargin = 30,
                            height = 80,
                            halign = "left",
                            valign = "center",
                            bgimage = "panels/square.png",

                            refreshBuilder = function(element)
                                local culture = GetSelectedCulture()

                                element:SetClass("haveselection", culture.aspects[aspectEntry.id] ~= "")
                                if element:HasClass("haveselection") and culture.aspects[aspectEntry.id] == k then
                                    element:SetClass("selected", true)
                                else
                                    element:SetClass("selected", false)
                                end
                            end,

                            hover = function(element)
                                m_aspectHovered = k
                                CharacterSheet.instance:FireEvent("refreshAll")
                                CharacterSheet.instance:FireEventTree("refreshBuilder")
                            end,

                            dehover = function(element)
                                if m_aspectHovered == k then
                                    m_aspectHovered = nil
                                end
                                CharacterSheet.instance:FireEvent("refreshAll")
                                CharacterSheet.instance:FireEventTree("refreshBuilder")
                            end,

                            press = function(element)
                                local culture = GetSelectedCulture()
                                if culture.aspects[aspectEntry.id] == k then
                                    culture.aspects[aspectEntry.id] = ""
                                else
                                    culture.aspects[aspectEntry.id] = k
                                end
                                CharacterSheet.instance:FireEvent("refreshAll")
                                CharacterSheet.instance:FireEventTree("refreshBuilder")
                            end,

                            gui.Panel{
                                classes = {"careerIcon"},
                                interactable = false,
                                width = 64,
                                height = 64,
                                valign = "center",
                                hmargin = 8,
                                bgimage = "panels/square.png",
                                bgcolor = iconColor,
                            },
                            gui.Label{
                                classes = {"careerLabel"},
                                interactable = false,
                                text = aspect.name,
                                fontSize = 24,
                                minFontSize = 8,
                                color = Styles.textColor,
                                maxWidth = 180,
                                textWrap = false,
                                width = "auto",
                                height = "auto",
                                halign = "left",
                            },
                        }

                        children[#children+1] = panel
                    end
                end

                local aspectPanelHeading = gui.Label{
                    width = "100%",
                    height = 24,
                    textAlignment = "center",
                    fontSize = 36,
                    bold = true,
                    text = aspectEntry.text,
                }

                local aspectPanel = gui.Panel{
                    width = "100%",
                    height = "auto",
                    flow = "horizontal",
                    wrap = true,
                    children = children
                }

                aspectPanels[#aspectPanels+1] = aspectPanelHeading
                aspectPanels[#aspectPanels+1] = aspectPanel
            end

            element.children = aspectPanels

            element:FireEventTree("refreshBuilder")
        end,
    }

    rightPanel = gui.Panel{
        width = "40%",
        height = "100%",
        halign = "center",
        flow = "vertical",

        descriptionContainer,
    }

    local args = {
		width = "100%",
		height = "100%",
		flow = "horizontal",
		halign = "center",
		valign = "center",

        refreshBuilder = function(element)
            local creature = CharacterSheet.instance.data.info.token.properties

            --make sure the creature's culture is initialized.
            if creature.culture.init == false and creature.typeName == "character" then
                creature.culture = Culture.CreateNew()
            end
        end,

        leftPanel,
        rightPanel,
    }

    for k,v in pairs(options) do
        args[k] = v
    end

    resultPanel = gui.Panel(args)

    resultPanel:FireEventTree("targetIndexChanged")

    return resultPanel
end