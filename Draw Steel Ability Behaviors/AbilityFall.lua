local mod = dmhub.GetModLoading()

RegisterGameType("ActivatedAbilityFallBehavior", "ActivatedAbilityBehavior")

ActivatedAbility.RegisterType
{
	id = 'fall',
	text = 'Fall',
	createBehavior = function()
		return ActivatedAbilityFallBehavior.new{
		}
	end
}

ActivatedAbilityFallBehavior.summary = 'Fall'

function ActivatedAbilityFallBehavior:Cast(ability, casterToken, targets, options)
    for _, target in ipairs(targets) do
        if target.token ~= nil then
            target.token:TryFall()
        end
    end
end

function ActivatedAbilityFallBehavior:EditorItems(parentPanel)
	local result = {}
	self:ApplyToEditor(parentPanel, result)
	self:FilterEditor(parentPanel, result)
	return result
end