local mod = dmhub.GetModLoading()

--- @class ActivatedAbilityDestroyBehavior:ActivatedAbilityBehavior
ActivatedAbilityDestroyBehavior = RegisterGameType("ActivatedAbilityDestroyBehavior", "ActivatedAbilityBehavior")

ActivatedAbilityDestroyBehavior.summary = 'Destroys Creatures'

ActivatedAbility.RegisterType
{
	id = 'destroy',
	text = 'Destroy',
	createBehavior = function()
		return ActivatedAbilityDestroyBehavior.new{
		}
	end
}

function ActivatedAbilityDestroyBehavior:Cast(ability, casterToken, targets, options)

	local tokenids = ActivatedAbility.GetTokenIds(targets)

    ability:CommitToPaying(casterToken, options)

	for i,target in ipairs(targets) do
		local targetCreature = target.token.properties

		target.token:ModifyProperties{
			description = "Destroyed",
			execute = function()
				targetCreature:Destroy(string.format("Destroyed by %s", ability.name))
			end
		}
	end
end

function ActivatedAbilityDestroyBehavior:EditorItems(parentPanel)
	local result = {}
	self:ApplyToEditor(parentPanel, result)
	self:FilterEditor(parentPanel, result)
	return result
end
