local mod = dmhub.GetModLoading()

--- @class ActivatedAbilityDisguiseBehavior:ActivatedAbilityBehavior
ActivatedAbilityDisguiseBehavior = RegisterGameType("ActivatedAbilityDisguiseBehavior", "ActivatedAbilityBehavior")

ActivatedAbilityDisguiseBehavior.summary = 'Disguises as Another Creature'
ActivatedAbilityDisguiseBehavior.mode = 'target'
ActivatedAbilityDisguiseBehavior.monsterType = 'none'

ActivatedAbility.RegisterType
{
	id = 'disguise',
	text = 'Disguise',
	createBehavior = function()
		return ActivatedAbilityDisguiseBehavior.new{
		}
	end
}

function ActivatedAbilityDisguiseBehavior:Cast(ability, casterToken, targets, options)
    if self.mode == "bestiary" then
        for _,target in ipairs(targets) do
            local tok = target.token
            if tok ~= nil and tok.valid then
                local monster = assets.monsters[self.monsterType]
                if monster ~= nil then
                    tok:DisguiseAs(monster.info)
                end
            end
        end
    else
        for _,target in ipairs(targets) do
            local tok = target.token
            if tok ~= nil and tok.valid then
                casterToken:DisguiseAs(tok)
                break
            end
        end
    end
end

function ActivatedAbilityDisguiseBehavior:EditorItems(parentPanel)
    local panel = gui.Panel{
        width = "100%",
        height = "auto",
        flow = "vertical",
    }

    local Refresh
    Refresh = function()
        local children = {}

        children[#children+1] = gui.Panel{
            classes = {"formPanel"},
            gui.Label{
                classes = {"formLabel"},
                text = "Mode",
            },
            gui.Dropdown{
                classes = {"formDropdown"},
                options = {
                    {text = "Target Creature", id = "target"},
                    {text = "From Monster Book", id = "bestiary"},
                },

                idChosen = self.mode,
                change = function(element)
                    self.mode = element.idChosen
                    Refresh()
                end,
            }
        }

        if self.mode == "bestiary" then
            local monsterOptions = {}
            for key,monster in pairs(assets.monsters) do
                if not monster.hidden and monster.name ~= nil then
                    monsterOptions[#monsterOptions+1] = {
                        id = key,
                        text = monster.name,
                    }
                end
            end

            children[#children+1] = gui.Panel{
                classes = {"formPanel"},
                gui.Label{
                    classes = {"formLabel"},
                    text = "Monster",
                },
                gui.Dropdown{
                    classes = {"formDropdown"},
                    options = monsterOptions,
                    idChosen = self.monsterType,
                    sort = true,
                    hasSearch = true,
                    change = function(element)
                        self.monsterType = element.idChosen
                    end,
                }
            }
        end

        panel.children = children
    end

    Refresh()

    return {panel}
end