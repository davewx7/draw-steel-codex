local mod = dmhub.GetModLoading()

---@class RichCounter
RichCounter = RegisterGameType("RichCounter", "RichTag")
RichCounter.tag = "counter"
RichCounter.pattern = "^(?<number>[0-9]+)$"

function RichCounter.CreateDisplay(self)
    local resultPanel

    local m_token

    resultPanel = gui.Panel{
        bgimage = true,
        bgcolor = "black",
        borderColor = "white",
        borderWidth = 2,
        width = 64,
        height = 30,
        halign = "left",
        gui.Label{
            styles = {
                {
                    selectors = {"uploading"},
                    opacity = 0.4,
                }
            },
            width = "100%",
            height = "100%",
            fontSize = 20,
            textAlignment = "center",
            bold = true,
            characterLimit = 3,
            editable = dmhub.isDM,
            refreshTag = function(element, tag, match, token)
                self = tag or self
                element.text = match.number
                m_token = token
                element:SetClass("uploading", false)
            end,
            change = function(element)
                local n = tonumber(element.text)
                if n ~= nil then
                    n = round(n)
                end

                n = n or tonumber(element.text) or 0

                if m_token ~= nil and self:GetDocument() ~= nil then
                    local doc = self:GetDocument()
                    doc:PatchToken(m_token, string.format("[[%d]]", n))
                    doc:Upload()
                    element:SetClass("uploading", true)
                end
            end,
        },
    }

    return resultPanel
end


MarkdownDocument.RegisterRichTag(RichCounter)