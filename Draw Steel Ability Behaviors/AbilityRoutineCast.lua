local mod = dmhub.GetModLoading()

--- @class ActivatedAbilityRoutineControlBehavior:ActivatedAbilityBehavior
RegisterGameType("ActivatedAbilityRoutineControlBehavior", "ActivatedAbilityBehavior")

ActivatedAbilityRoutineControlBehavior.summary = "Routine Control"
ActivatedAbilityRoutineControlBehavior.triggerOnly = true

ActivatedAbility.RegisterType
{
	id = 'rouitineControl',
	text = 'Routine Control',
	createBehavior = function()
		return ActivatedAbilityRoutineControlBehavior.new{
		}
	end
}

function ActivatedAbilityRoutineControlBehavior:EditorItems(parentPanel)
	local result = {}
	self:ApplyToEditor(parentPanel, result)
	self:FilterEditor(parentPanel, result)
	return result
end

function ActivatedAbilityRoutineControlBehavior:Cast(ability, casterToken, targets, options)

    local resultPanel = nil
    local finished = false
    local canceled = false

    local caster = casterToken:GetCreature()

    local selectedRoutine = caster:try_get("routineSelected")

    local createRoutineAbilityPanel = function(ability)
        local abilityPanel = gui.Panel{
            width = "auto",
            height = 35,
            halign = "left",
            flow = "horizontal",
            vmargin = 3,
            data = {
                ability = ability,
            },
            gui.Label{
                text = ability.name,
                color = Styles.textColor,
                height = 16,
                width = "auto",
                valign = "center",
                fontSize = 16,

                hover = gui.Tooltip(ability.effect)
            },
            gui.Button{
                classes = {'effect-button'},
                halign = "center",
                text = "Select",
                click = function(element)
                    if selectedRoutine == ability.guid then
                        selectedRoutine = nil
                    else
                        selectedRoutine = ability.guid
                    end
                    
                    local routinePanel = element:Get("routineAbilityPanel")
                    if routinePanel and routinePanel.children then
                        for _, child in pairs(routinePanel.children) do
                            if child.children and child.children[2] then
                                child.children[2]:RemoveClass("selected")
                            end
                        end
                    end
                    
                    if selectedRoutine == ability.guid then
                        element:AddClass("selected")
                    end
                end,

                create = function(element)
                    if selectedRoutine == ability.guid then
                        element:AddClass("selected")
                    end
                end,
            },
        }

        return abilityPanel
    end


    local routineAbilities = caster:GetRoutines()
    local routineAbilityPanel = nil
    routineAbilityPanel = gui.Panel{
        id = "routineAbilityPanel",
        width = "auto",
        height = "auto",
        halign = "left",
        valign = "top",
        flow = "vertical",

        create = function(element)
            local children = {}
            for _, ability in pairs(routineAbilities or {}) do
                local abilityEntry = createRoutineAbilityPanel(ability)
                children[#children+1] = abilityEntry
            end
            element.children = children
        end,
    }

    resultPanel = gui.Panel{
        classes = {"framedPanel"},
        bgimage = 'panels/square.png',
        bgcolor = Styles.backgroundColor,
        borderColor = Styles.textColor,
        borderWidth = 2,
        width = 550,
        height = 550,

        styles = {
            {
                classes = {'effect-button'},
                width = "auto",
                height = "auto",
                halign = "left",
                fontSize = 14,
                margin = 4,
                pad = 2,
            },
            {
                classes = {'effect-button' , 'selected'},
                borderColor = 'white',
				borderWidth = 2,
				bgcolor = '#882222',
            },
            {
                classes = {'routine-label'},
                color = Styles.textColor,
                valign = "top",
                width = "auto",
                fontSize = 20,
                bold = true,
            }
		},

        gui.Panel{
            flow = "vertical",
            width = "90%",
            height = "90%",
            valign = "top",
            halign = "center",
            gui.Label{
                classes = {"routine-label"},
                text = ability.name or "Routine Control",
            },

            routineAbilityPanel,

            gui.Button{
                halign = 'right',
                valign = 'bottom',
                text = 'Submit',
                height = 30,
                width = 160,
                click = function(element)
                    casterToken:ModifyProperties{
                        description = "Routine Selection",
                        execute = function()
                            if selectedRoutine then
                                casterToken.properties.routineSelected = selectedRoutine
                            else
                                casterToken.properties.routineSelected = nil
                            end
                        end,
                    }
                    finished = true
                    gui.CloseModal()
                end,
            },
            gui.Button{
                halign = 'right',
                valign = 'bottom',
                text = 'Cancel',
                width = 160,
                escapeActivates = true,
                escapePriority = EscapePriority.EXIT_MODAL_DIALOG,
                click = function(element)
                    finished = true
                    canceled = true
                    gui.CloseModal()
                end,
            },
        },

    }

    gui.ShowModal(resultPanel)

    while not finished do
        coroutine.yield(0.1)
    end

    --Canceling stops the ability from executing
    if canceled then
        return
    end

end