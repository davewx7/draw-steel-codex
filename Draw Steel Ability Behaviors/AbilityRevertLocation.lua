local mod = dmhub.GetModLoading()

---@class ActivatedAbilityRevertLocBehavior : ActivatedAbilityBehavior
ActivatedAbilityRevertLocBehavior = RegisterGameType("ActivatedAbilityRevertLocBehavior", "ActivatedAbilityBehavior")

ActivatedAbility.RegisterType
{
	id = 'revertloc',
	text = 'Revert Location',
	createBehavior = function()
		return ActivatedAbilityRevertLocBehavior.new{
            distance = 1,
		}
	end
}

ActivatedAbilityRevertLocBehavior.summary = 'Revert Location'

function ActivatedAbilityRevertLocBehavior:SummarizeBehavior(ability, creatureLookup)
	return string.format("Revert Location for %s", ability.name)
end

function ActivatedAbilityRevertLocBehavior:Cast(ability, casterToken, targets, options)
	if #targets == 0 then
		return
	end

    for _,target in ipairs(targets) do
        if target.token ~= nil then
            local path = options.symbols["path"]
            print("PATH::", path ~= nil and #path.path.steps)

            if path ~= nil then
                for _,step in ipairs(path.path.steps) do
                    if casterToken:Distance(step) <= self.distance then
                        print("PATH:: RELOCATE:", step.x, step.y, step)
                        local currentLoc = target.token.loc
                        if currentLoc.x == step.x and currentLoc.y == step.y then
                            print("PATH:: SAME LOCATION, SKIP")
                            break
                        end
                        target.token:ChangeLocation(step)
                        break
                    end
                end
            end
            
        end
    end
end

function ActivatedAbilityRevertLocBehavior:EditorItems(parentPanel)
	local result = {}
	self:ApplyToEditor(parentPanel, result)
	self:FilterEditor(parentPanel, result)

    result[#result+1] = gui.Panel{
        classes = {"formPanel"},
        gui.Label{
            classes = {"formLabel"},
            text = "Distance:",
        },
        gui.Input{
            classes = {"formInput"},
            text = string.format("%d", tonumber(self.distance)),
            change = function(element)
                local v = tonumber(element.text)
                if v ~= nil and v >= 0 then
                    self.distance = round(v)
                else
                    element.text = string.format("%d", round(self.distance))
                end
            end,
            width = "100%",
            height = "auto",
            fontSize = 14,
            minFontSize = 6,
        }
    }

    return result
end