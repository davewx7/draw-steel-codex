local mod = dmhub.GetModLoading()

LaunchablePanel.Register{
	name = "Regex Matcher",
    folder = "Development Tools",

    icon = "panels/initiative/initiative-icon.png",
	halign = "center",
	valign = "center",
    draggable = true,

	content = function(args)
        local m_pattern = ""
        local m_text = ""
        local resultPanel
        resultPanel = gui.Panel{
            width = 900,
            height = 768,
            gui.Label{
                valign = "top",
                halign = "center",
                fontSize = 24,
                width = "auto",
                height = "auto",
                text = "Regular Expression Matcher",
            },

            gui.Panel{
                halign = "center",
                valign = "center",
                flow = "vertical",
                width = "90%",
                height = 600,

                gui.Input{
                    placeholderText = "Enter Regular Expression",
                    width = 600,
                    height = 22,
                    fontSize = 16,
                    fontFace = "courier",
                    vmargin = 16,
                    halign = "center",
                    valign = "top",
                    editlag = 0.1,
                    edit = function(element)
                        m_pattern = element.text
                        resultPanel:FireEventTree("regex")
                    end,
                },

                gui.Input{
                    placeholderText = "Enter Text...",
                    width = 600,
                    minHeight = 22,
                    height = "auto",
                    textWrap = true,
                    fontSize = 16,
                    fontFace = "courier",
                    vmargin = 16,
                    halign = "center",
                    valign = "top",
                    editlag = 0.1,
                    edit = function(element)
                        m_text = element.text
                        resultPanel:FireEventTree("regex")
                    end,
                },

                gui.Label{
                    text = "",
                    fontSize = 16,
                    width = "auto",
                    height = "auto",
                    halign = "center",
                    valign = "center",
                    regex = function(element)
                        if m_text == "" and m_pattern == "" then
                            element.text = ""
                            return
                        end
                        local match = regex.MatchGroups(m_text, m_pattern:gsub("\\\\", "\\"))
                        if match ~= nil then
                            local text = "Match!\n"
                            for key,value in pairs(match) do
                                text = text .. "\n" .. key .. " = " .. value
                            end
                            element.text = text
                        else
                            element.text = "No Match"
                        end
                    end,
                },
            }
        }

        return resultPanel
	end,
}
