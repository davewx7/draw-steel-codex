local mod = dmhub.GetModLoading()

--controls text showing up when a player is moving.
CharacterModifier.RegisterType('movementtext', "Movement Advisory Text")

CharacterModifier.TypeInfo.movementtext = {
    init = function(modifier)
        modifier.text = ""
        modifier.color = "white"
    end,

    MovementAdvisoryText = function(modifier, creature, path, text)
        if modifier:try_get("movementType", "all") == "shift" and (not path.shifting) then
            return text
        end

        local s = StringInterpolateGoblinScript(modifier.text, creature:LookupSymbol{
            path = PathMoved.new{path = path},
        })

        return string.format("%s\n\n<color=%s>%s</color>", text, modifier.color, s)
    end,

    createEditor = function(modifier, element)
        local Refresh
        local firstRefresh = true

        Refresh = function()
            if firstRefresh then
                firstRefresh = false
            else
                element:FireEvent("refreshModifier")
            end

            local children = {}
			children[#children+1] = modifier:FilterConditionEditor()

            children[#children+1] = gui.Panel{
                classes = {'formPanel'},
                children = {
                    gui.Label{
                        text = 'Color:',
                        classes = {'formLabel'},
                    },
                    gui.Dropdown{
                        options = {
                            { id = "white", text = "White"},
                            { id = "red", text = "Red"},
                            { id = "green", text = "Green"},
                        },
                        idChosen = modifier.color,
                        change = function(self)
                            modifier.color = self.idChosen
                            Refresh()
                        end,
                    },
                },
            }

            children[#children+1] = gui.Panel{
                classes = {"formPanel"},
                gui.Label{
                    classes = {"formLabel"},
                    text = "Movement Type:",
                },
                gui.Dropdown{
                    classes = {"formDropdown"},
                    options = {
                        {
                            id = "all",
                            text = "All",
                        },
                        {
                            id = "shift",
                            text = "Shift",
                        },
                    },
                    idChosen = modifier:try_get("movementType", "all"),
                    change = function(element)
                        modifier.movementType = element.idChosen
                        Refresh()
                    end,
                }
            }

            children[#children+1] = gui.Panel{
                classes = {'formPanel'},
                children = {
                    gui.Label{
                        text = 'Text:',
                        classes = {'formLabel'},
                    },
                    gui.Input{
                        selfStyle = {
                            height = 30,
                            width = 260,
                        },
                        multiline = true,
                        characterLimit = 256,
                        text = modifier.text or "",
                        change = function(self)
                            modifier.text = self.text
                            Refresh()
                        end,
                    },
                },
            }

            element.children = children
        end

        Refresh()
    end,
}

function CharacterModifier:MovementAdvisoryText(creature, path, text)
	local typeInfo = CharacterModifier.TypeInfo[self.behavior] or {}
	if typeInfo.MovementAdvisoryText ~= nil then
        text = typeInfo.MovementAdvisoryText(self, creature, path, text)
	end
    return text
end