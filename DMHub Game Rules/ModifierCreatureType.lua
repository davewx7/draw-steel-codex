local mod = dmhub.GetModLoading()

CharacterModifier.RegisterType('creaturetype', "Modify Creature Type")


CharacterModifier.TypeInfo.creaturetype = {

	init = function(modifier)
        modifier.monsterType = "Undead"
        modifier.addType = false --instead replaces type.
    end,

    createEditor = function(modifier, element)
        local Refresh

        Refresh = function()

            local children = {}

            children[#children+1] = gui.Panel{
                classes = {"formPanel"},
                gui.Label{
                    text = "Mode",
                    classes = {"formLabel"},
                },
                gui.Dropdown{
                    options = {
                        {
                            id = "add",
                            text = "Add Type",
                        },
                        {
                            id = "replace",
                            text = "Replace Type",
                        },
                    },

                    idChosen = cond(modifier.addType, "add", "replace"),
                    change = function(element)
                        modifier.addType = (element.text == "add")
                        Refresh()
                    end,
                }
            }

            children[#children+1] = gui.Panel{
                classes = {"formPanel"},
                gui.Label{
                    text = "Monster Type:",
                    classes = {"formLabel"},
                },
                gui.Input{
                    text = modifier.monsterType,
                    characterLimit = 22,
                    change = function(element)
                        modifier.monsterType = element.text
                        Refresh()
                    end,
                }
            }

            element.children = children
        end

        Refresh()
    end,

    modifyCreatureTypes = function(modifier, symbols, creatureTypes)
        if modifier.addType then
            for _,t in ipairs(creatureTypes) do
                if t == modifier.monsterType then
                    return creatureTypes
                end
            end

            local result = {modifier.monsterType}
            for _,t in ipairs(creatureTypes) do
                result[#result+1] = t
            end

            return result
        else
            return {modifier.monsterType}
        end
    end,

}

function CharacterModifier:ModifyCreatureTypes(modInfo, symbols, creatureTypes)
	local typeInfo = CharacterModifier.TypeInfo[self.behavior] or {}
	if typeInfo.modifyCreatureTypes ~= nil then
        return typeInfo.modifyCreatureTypes(self, symbols, creatureTypes)
    end

    return creatureTypes
end