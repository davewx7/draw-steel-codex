local mod = dmhub.GetModLoading()

RegisterGameType("ActivatedAbilityCustomTriggerBehavior", "ActivatedAbilityBehavior")

ActivatedAbilityCustomTriggerBehavior.summary = 'Custom Trigger'

ActivatedAbility.RegisterType
{
    id = "customtrigger",
    text = "Custom Trigger",
    createBehavior = function()
        return ActivatedAbilityCustomTriggerBehavior.new{
            triggerName = "",
            value = "",
        }
    end,
}

function ActivatedAbilityCustomTriggerBehavior:SummarizeBehavior(ability, creatureLookup)
    return "Custom Trigger"
end

function ActivatedAbilityCustomTriggerBehavior:Cast(ability, casterToken, targets, options)
    for _,target in ipairs(targets) do
        if target.token ~= nil then
            options.symbols.target = target.token.properties
            local value = dmhub.EvalGoblinScriptDeterministic(self.value, target.token.properties:LookupSymbol(options.symbols), 0, "Determine custom trigger value")
            print("GoblinScript:: symbols", options.symbols, "self.value =", self.value, "result =", value)

            target.token.properties:DispatchEvent("custom", {
                triggername = self.triggerName,
                triggervalue = value,
            })
        end
    end
end

function ActivatedAbilityCustomTriggerBehavior:EditorItems(parentPanel)
	local result = {}
	self:ApplyToEditor(parentPanel, result)
	self:FilterEditor(parentPanel, result)

    result[#result+1] = gui.Panel{
        classes = {"formPanel"},
        gui.Label{
            classes = {"formLabel"},
            text = "Trigger Name:",
        },
        gui.Input{
            classes = {"formInput"},
            text = self.triggerName,
            change = function(element)
                self.triggerName = element.text
            end,
        },
    }

    result[#result+1] = gui.Panel{
        classes = {"formPanel"},
        gui.Label{
            classes = {"formLabel"},
            text = "Value:",
        },
        gui.GoblinScriptInput{
            value = self.value,
            change = function(element)
                self.value = element.value
            end,
            documentation = {
				domains = parentPanel.data.parentAbility.domains,
                help = string.format("This GoblinScript is used to determine the value passed with the custom trigger being fired."),
                output = "number",
                subject = creature.helpSymbols,
                subjectDescription = "The creature that is casting the ability causing the trigger.",
                symbols = ActivatedAbility.helpCasting,
            }
        }
    }

	return result
end