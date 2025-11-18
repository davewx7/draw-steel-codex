local mod = dmhub.GetModLoading()

RegisterGameType("ActivatedAbilitySaveBehavior", "ActivatedAbilityBehavior")

ActivatedAbilitySaveBehavior.summary = 'Draw Steel Save'
ActivatedAbilitySaveBehavior.conditionsMode = 'all'
ActivatedAbilitySaveBehavior.rollMode = 'roll' --roll or purge with no roll

ActivatedAbility.RegisterType
{
    id = 'draw_steel_save',
    text = 'Draw Steel Save',
    createBehavior = function()
        return ActivatedAbilitySaveBehavior.new{
        }
    end
}

function ActivatedAbilitySaveBehavior:SummarizeBehavior(ability, creatureLookup)
    return "Save"
end

local g_tableStyles = {
    gui.Style{
        selectors = {"hover"},
        priority = 20,
        bgcolor = "black",
    },
    gui.Style{
        selectors = {"selected", "row"},
        priority = 20,
        bgcolor = Styles.textColor,
    },
    gui.Style{
        selectors = {"selected", "label"},
        priority = 20,
        color = "black",
    },
    gui.Style{
        selectors = {"selected", "iconBorder"},
        priority = 20,
        borderColor = "black",
    },
    gui.Style{
        selectors = {"selected", "iconBackground"},
        priority = 20,
        bgimage = "panels/square.png",
        bgcolor = "black",
    },
}

function ActivatedAbilitySaveBehavior:Cast(ability, casterToken, targets, options)
    local conditionsTable = dmhub.GetTable(CharacterCondition.tableName) or {}
    for _,target in ipairs(targets) do
        if target.token ~= nil then
            if self.conditionsMode == "one" then
                local conditionChoices = {}
                local chosenKey = nil
                local isOngoingEffect = false
                for key,entry in pairs(target.token.properties:try_get("inflictedConditions", {})) do
                    local conditionInfo = conditionsTable[key]
                    if (entry.duration ~= nil and entry.duration ~= "eoe") or (conditionInfo ~= nil and self:try_get("includeProne") and string.lower(conditionInfo.name) == "prone") then


                        conditionChoices[#conditionChoices+1] = {
                            text = conditionInfo.name,
                            click = function()
                                chosenKey = key
                                isOngoingEffect = false
                            end,
                        }
                    end
                end

                local ongoingEffects = target.token.properties:ActiveOngoingEffects()

                for _,effectInstance in ipairs(ongoingEffects) do
                    if effectInstance.removeOnSave then
                        local t = dmhub.GetTable(CharacterOngoingEffect.tableName)
                        local ongoingEffectEntry = t[effectInstance.ongoingEffectid]
                        if ongoingEffectEntry ~= nil then
                            conditionChoices[#conditionChoices+1] = {
                                text = ongoingEffectEntry.name,
                                click = function()
                                    chosenKey = effectInstance.id
                                    isOngoingEffect = true
                                end,
                            }    
                        end
                    end
                end

                if #conditionChoices > 0 then
                    local dialog = GameHud.instance:ModalChoice{
                        title = "Choose Condition",
                        options = conditionChoices,
                    }

                    while chosenKey == nil and dialog ~= nil and dialog.valid do
                        coroutine.yield()
                    end

                    if isOngoingEffect then
                        target.token.properties:RollOngoingEffectSave(chosenKey, {alreadyInCoroutine = true})
                    elseif self.rollMode == "roll" then
                        target.token.properties:RollConditionSave(chosenKey, {alreadyInCoroutine = true})
                    else
                        target.token.properties:InflictCondition(chosenKey, {purge = true})
                    end
                    ability:CommitToPaying(casterToken, options)

                end
            else

                for conditionid,entry in pairs(target.token.properties:try_get("inflictedConditions", {})) do
                    if self.rollMode == "roll" then
                        target.token.properties:RollConditionSave(conditionid, {alreadyInCoroutine = true})
                    else
                        target.token.properties:InflictCondition(conditionid, {purge = true})
                    end
                    ability:CommitToPaying(casterToken, options)
                end

                --now look at any ongoing effects with 'save ends' ending.
                local ongoingEffects = target.token.properties:ActiveOngoingEffects()

                for _,effectInstance in ipairs(ongoingEffects) do
                    if effectInstance.removeOnSave then
                        target.token.properties:RollOngoingEffectSave(effectInstance.id, {alreadyInCoroutine = true})
                    end
                end
            end
        end
    end
end

function ActivatedAbilitySaveBehavior:EditorItems(parentPanel)
	local result = {}
	self:ApplyToEditor(parentPanel, result)
	self:FilterEditor(parentPanel, result)

    result[#result+1] = gui.Panel{
        classes = "formPanel",
        gui.Label{
            classes = "formLabel",
            text = "Conditions:",
        },

        gui.Dropdown{
            classes = "formDropdown",
            halign = "left",
            idChosen = self.conditionsMode,
            options = {
                { id = "all", text = "All Conditions" },
                { id = "one", text = "One Chosen Condition" },
            },
            change = function(element)
                self.conditionsMode = element.idChosen
                --parentPanel:FireEvent("refreshBehavior")
            end,

        },
    }

    --do prone.
    result[#result+1] = gui.Check{
        text = "Include Prone",
        value = self:try_get("includeProne", false),
        change = function(element)
            self.includeProne = element.value
        end,
    }

    result[#result+1] = gui.Panel{
        classes = "formPanel",
        gui.Label{
            classes = "formLabel",
            text = "Roll Mode:",
        },

        gui.Dropdown{
            classes = "formDropdown",
            halign = "left",
            idChosen = self.rollMode,
            options = {
                { id = "roll", text = "Roll" },
                { id = "purge", text = "Remove Without Roll" },
            },
            change = function(element)
                self.rollMode = element.idChosen
                --parentPanel:FireEvent("refreshBehavior")
            end,

        },
    }

    return result
end