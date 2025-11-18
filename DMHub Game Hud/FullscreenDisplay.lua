local mod = dmhub.GetModLoading()

RegisterGameType("FullscreenDisplay")

FullscreenDisplay.docid = "fullscreen_display"

function FullscreenDisplay.Create(options)
    local belowui = options.belowui or false
	local doc = mod:GetDocumentSnapshot(FullscreenDisplay.docid)
    local displayPanel = gui.Panel{
        classes = {"hidden"},
        width = "100%",
        height = "100%",
        bgimage = doc.data.coverart,
        bgcolor = "white",

        styles = {
            {
                selectors = {"~dm", "closebutton"},
                hidden = 1,
            }
        },


        gui.CloseButton{
            classes = {"closebutton"},
            halign = "right",
            valign = "top",
            hmargin = 8,
            vmargin = 8,
            width = 24,
            height = 24,

            click = function(element)
	            local doc = mod:GetDocumentSnapshot(FullscreenDisplay.docid)
                doc:BeginChange()
                doc.data.show = true --hide from dm but not players.
                doc:CompleteChange("Hide Fullscreen Display")
            end,
        },

    }

    return gui.Panel{
        width = "100%",
        height = "100%",
        valign = "bottom",
        displayPanel,

        data = {
            presentationInfo = nil,
        },

        monitorGame = doc.path,

        refreshGame = function(element)
	        local doc = mod:GetDocumentSnapshot(FullscreenDisplay.docid)
            displayPanel.bgimage = doc.data and doc.data.coverart
            displayPanel:SetClass("hidden", doc.data == nil or (doc.data.belowui or false) ~= belowui or (not doc.data.show) or (doc.data.show ~= "all" and dmhub.isDM))

            if doc.data == nil or (not doc.data.show) or not dmhub.isDM then
                if element.data.presentationInfo ~= nil then
                    TopBar.ClearPresentationInfo(element.data.presentationInfo.id)
                    element.data.presentationInfo = nil
                end
            else
                local info = element.data.presentationInfo or {}
                info.id = info.id or dmhub.GenerateGuid()
                info.text = "Show Scene"
                info.onchange = info.onchange or function(value)
                    local doc = FullscreenDisplay.GetDocumentSnapshot()
                    doc:BeginChange()
                    doc.data.show = value
                    doc:CompleteChange("Show Fullscreen Display")
                end
                info.options = info.options or {
                    {
                        id = false,
                        text = "Hide",
                        execute = function()
                        end,
                    },
                    {
                        id = true,
                        text = "Players",
                        execute = function()
                        end,
                    },
                    {
                        id = "all",
                        text = "All",
                        execute = function()
                        end,
                    }
                }
                info.value = doc.data.show
                TopBar.SetPresentationInfo(info)
                element.data.presentationInfo = info
            end
        end,
    }
end

function FullscreenDisplay.GetDocumentSnapshot()
	local doc = mod:GetDocumentSnapshot(FullscreenDisplay.docid)
    return doc
end