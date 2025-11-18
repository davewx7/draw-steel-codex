local mod = dmhub.GetModLoading()

---@class RichMacro
RichMacro = RegisterGameType("RichMacro", "RichTag")
RichMacro.tag = "macro"
RichMacro.pattern = "^/(?<command>.+)\\|(?<text>.*)$"

function RichMacro.CreateDisplay(self)
    local resultPanel
    print("MACRO:: CREATE")
    local m_command

    resultPanel = gui.Button {
        width = "auto",
        height = "auto",
        fontSize = 16,
        refreshTag = function(element, tag, match, token)
            m_command = match.command
            element.text = match.text
            element.selfStyle.halign = token.justification or "left"
        end,
        press = function(element)
            dmhub.Execute(m_command)
        end,
        rightClick = function(element)
            element.popup = gui.ContextMenu {
                entries = {
                    {
                        text = "Copy Command",
                        click = function()
                            dmhub.CopyToClipboard("/" .. m_command)
                            element.popup = nil
                        end,
                    }
                }
            }
        end
    }

    return resultPanel
end

MarkdownDocument.RegisterRichTag(RichMacro)
