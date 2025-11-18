local mod = dmhub.GetModLoading()

RegisterGameType("ActivatedAbilityConditionSourceBehavior", "ActivatedAbilityBehavior")

ActivatedAbility.RegisterType{
    id = 'condition_source',
    text = 'Set Source of Condition',
    createBehavior = function()
        return ActivatedAbilityConditionSourceBehavior.new{
            condid = CharacterCondition.conditionsByName["frightened"].id,
        }
    end
}

ActivatedAbilityConditionSourceBehavior.summary = 'Set Source of Condition'

function ActivatedAbilityConditionSourceBehavior:Cast(ability, casterToken, targets, options)
    local cast = options.symbols.cast

    for _,target in ipairs(targets) do
        local affectedCreatures = cast:try_get("inflictedConditions", {})[self.condid]
        for _,charid in ipairs(affectedCreatures or {}) do
            local affectedToken = dmhub.GetTokenById(charid)
            if affectedToken ~= nil then
                affectedToken:ModifyProperties{
                    description = "Set source of condition",
                    execute = function()
                        affectedToken.properties:SetInflictedConditionSource(self.condid, {tokenid = target.token.charid})
                    end,
                }
            end
        end
    end
end

function ActivatedAbilityConditionSourceBehavior:EditorItems(parentPanel)
	local result = {}
	self:ApplyToEditor(parentPanel, result)
	self:FilterEditor(parentPanel, result)

    local conditionsTable = dmhub.GetTable(CharacterCondition.tableName)
    local options = {}
    for key,entry in unhidden_pairs(conditionsTable or {}) do
        if entry.trackCaster then
            options[#options+1] = {
                id = key,
                text = entry.name,
            }
        end
    end

    result[#result+1] = gui.Panel{
        classes = {"formPanel"},
        gui.Label{
            classes = {"formLabel"},
            text = "Condition:",
        },

        gui.Dropdown{
            options = options,
            idChosen = self.condid,
            change = function(element)
                self.condid = element.idChosen
            end,
        },
    }

    return result
end