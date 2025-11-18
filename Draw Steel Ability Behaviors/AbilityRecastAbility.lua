local mod = dmhub.GetModLoading()

--- @class ActivatedAbilityRecastBehavior:ActivatedAbilityBehavior
ActivatedAbilityRecastBehavior = RegisterGameType("ActivatedAbilityRecastBehavior", "ActivatedAbilityBehavior")

ActivatedAbilityRecastBehavior.summary = 'Recast Ability'
ActivatedAbilityRecastBehavior.mono = true
ActivatedAbilityRecastBehavior.hasCast = false

ActivatedAbility.RegisterType
{
	id = 'recast',
	text = 'Recast Ability',
	createBehavior = function()
		return ActivatedAbilityRecastBehavior.new{
		}
	end
}

function ActivatedAbilityRecastBehavior:SynthesizeAbilities(ability, creature)
    local messages = chat.messages
    local result = {}

    local filter = self:try_get("abilityFilter", "")

    for i=#messages,1,-1 do
        local message = messages[i]
        if message.messageType == "custom" and message.properties.typeName == "BeginRoundChatMessage" then
            break
        elseif message.messageType == "custom" and message.properties.typeName == "CastActivatedAbilityChatMessage" then

            local abilityCaster = dmhub.GetCharacterById(message.properties.casterid)
            if abilityCaster ~= nil then
                local abilityInfo = message.properties.ability

                local abilityCast = nil
                local candidateAbilities = abilityCaster.properties:GetActivatedAbilities()
                for _,a in ipairs(candidateAbilities) do
                    if a.name == abilityInfo.name then
                        local passesFilter = true
                        if filter ~= "" then
                            local symbols = {
                                ability = a,
                                caster = abilityCaster.properties,
                            }
                            passesFilter = GoblinScriptTrue(dmhub.EvalGoblinScriptDeterministic(filter, creature:LookupSymbol(symbols), 0, "Recast Ability Filter"))
                        end

                        if passesFilter then
                            abilityCast = a
                            break
                        end
                    end
                end

                if abilityCast ~= nil then
                    local alreadyFound = false
                    for _,existingAbility in ipairs(result) do
                        if existingAbility.guid == abilityCast.guid then
                            alreadyFound = true
                            break
                        end
                    end

                    if not alreadyFound then
                        abilityCast = DeepCopy(abilityCast)
                        result[#result+1] = abilityCast
                    end
                end
            end
        end
    end

    return result
end

function ActivatedAbilityRecastBehavior:EditorItems(parentPanel)
    local result = {}
    self:ApplyToEditor(parentPanel, result)
    self:FilterEditor(parentPanel, result)

    result[#result+1] = gui.Panel{
        classes = {"formPanel"},
        gui.Label{
            classes = {"formLabel"},
            text = "Ability Filter:",
        },
        gui.GoblinScriptInput{
            value = self:try_get("abilityFilter", ""),
            change = function(element)
                self.abilityFilter = element.value
            end,

            documentation = {
                help = "This GoblinScript is used to determine if this modifier filters an ability. If the result is true, the ability will be available, if it is false, the ability will be suppressed.",
                output = "boolean",
                subject = creature.helpSymbols,
                subjectDescription = "The creature that is affected by this modifier",
                symbols = {
                    ability = {
                        name = "Ability",
                        type = "ability",
                        desc = "The ability that is being checked for availability.",
                        examples = {
                            "Ability.Name = 'Hide'",
                            "Ability.Keywords has 'Fire'",
                        },
                    },
                    caster = {
                        name = "Caster",
                        type = "caster",
                        desc = "The original caster of the ability.",
                        examples = {
                            "Caster.Name = 'Bob'",
                            "Caster.Level > 5",
                        },
                    }
                }
            }
        }
    }
    return result
end