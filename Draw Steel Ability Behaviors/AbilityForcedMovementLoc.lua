local mod = dmhub.GetModLoading()


RegisterGameType("ActivatedAbilityForcedMovementLocBehavior", "ActivatedAbilityBehavior")

ActivatedAbility.RegisterType
{
	id = 'forcedmovementloc',
	text = 'Forced Movement Origin',
	createBehavior = function()
		return ActivatedAbilityForcedMovementLocBehavior.new{
            type = "aura",
		}
	end
}

ActivatedAbilityForcedMovementLocBehavior.summary = 'Forced Movement Origin'

function ActivatedAbilityForcedMovementLocBehavior:SummarizeBehavior(ability, creatureLookup)
    return "Forced Movement Origin"
end


function ActivatedAbilityForcedMovementLocBehavior:Cast(ability, casterToken, targets, options)
    if self.type == "aura" then
        local aura = options.symbols.aura
        if aura == nil or aura:GetArea() == nil then
            print("Origin: aura not found")
            return
        end

        local origin = aura:GetArea().origin
        options.symbols.forcedMovementOrigin = origin
        print("ORIGIN:: set origin =", origin.str)
    end
end


function ActivatedAbilityForcedMovementLocBehavior:EditorItems(parentPanel)
    local result = {}

    result[#result + 1] = gui.Panel {
        classes = { "formPanel" },
        gui.Label {
            classes = { "formLabel" },
            text = "Origin:",
        },

        gui.Dropdown {
            idChosen = "aura",
            options = {
                { id = 'aura', text = 'Center of Aura' },
            },
            change = function(element)
                self.type = element.idChosen
            end,
        }
    }

    return result
end