local mod = dmhub.GetModLoading()

--this implements the "transform" behavior for activated abilities.

RegisterGameType("ActivatedAbilityTransformBehavior", "ActivatedAbilityBehavior")

ActivatedAbility.RegisterType
{
	id = 'transform',
	text = 'Transform Creatures',
	createBehavior = function()
		return ActivatedAbilityTransformBehavior.new{
		}
	end
}

ActivatedAbilityTransformBehavior.summary = "Transform Creature"
ActivatedAbilityTransformBehavior.allCreaturesTheSame = false
ActivatedAbilityTransformBehavior.monsterType = "custom"
ActivatedAbilityTransformBehavior.bestiaryFilter = "beast.cr = 1 and beast.type is beast"
ActivatedAbilityTransformBehavior.casterChoosesCreatures = true
ActivatedAbilityTransformBehavior.replaceCaster = true
ActivatedAbilityTransformBehavior.hasReplaceCaster = true --do not display 'replace caster' in menu.



function ActivatedAbilityTransformBehavior:Cast(ability, casterToken, targets, args)


	if self:try_get("ongoingEffect") == nil then
		printf("TRANSFORM:: NO EFFECT")
		return
	end


	local summonedTokens = {}

	local chosenOption = nil

	for j,target in ipairs(targets) do

		local choices = {}
		for k,monster in pairs(assets.monsters) do
			args.symbols.beast = GenerateSymbols(monster.properties)
			args.symbols.target = GenerateSymbols(target.token.properties)
			if monster.properties:has_key("monster_type") and dmhub.EvalGoblinScriptDeterministic(self.bestiaryFilter, GenerateSymbols(casterToken.properties, args.symbols), 0, string.format("Bestiary filter for %s transform filter %s", ability.name, monster.properties.monster_type)) ~= 0 then
				choices[#choices+1] = monster
			end
		end

		args.symbols.target = nil
		args.symbols.beast = nil

		printf("TRANSFORM:: %s; same: %s / targets = %s", json(#choices), json(self.allCreaturesTheSame), json(#targets))

		table.sort(choices, function(a,b) return a.properties.monster_type < b.properties.monster_type end)

		if #choices ~= 0 then

			if j ~= 1 and self.allCreaturesTheSame and chosenOption ~= nil then
				--all creatures are the same so just maintain the chosen option.
				printf("TRANSFORM:: ALL THE SAME")

			elseif #choices > 1 and not self.casterChoosesCreatures then
				printf("TRANSFORM:: RANDOM")
				chosenOption = choices[math.random(#choices)]

			elseif #choices > 1 and self.casterChoosesCreatures then
				printf("TRANSFORM:: SHOW DIALOG")
				chosenOption = ActivatedAbilitySummonBehavior.ShowCreatureChoiceDialog(choices, {title = "Choose Transformation", buttonText = "Transform"})
				if chosenOption == nil then
					return
				end
			else
				chosenOption = choices[1]
			end

			local casterInfo = {
				tokenid = casterToken.id
			}
			if ability:RequiresConcentration() and casterToken.properties:HasConcentration() then
				casterInfo.concentrationid = casterToken.properties:MostRecentConcentration().id
			end

			--Okay to always provide a monsters temporary hitpoints when transforming?
			local tempHitpoints = nil
			if chosenOption and chosenOption.properties ~= nil then
				tempHitpoints = chosenOption.properties:TemporaryHitpoints()
			end

			if target.token.properties ~= nil then
				target.token:ModifyProperties{
					description = "Transform Creature",
					execute = function()
						local newEffect = target.token.properties:ApplyOngoingEffect(self.ongoingEffect, self:try_get("duration"), casterInfo, {
							transformid = chosenOption.id,
							untilEndOfTurn = self.durationUntilEndOfTurn,
							temporary_hitpoints = tempHitpoints,
						})
					end
				}
			end
		end
	end

	--we transformed creatures, so consume resources.
    ability:CommitToPaying(casterToken, args)
end

--build the fields used to edit a transform behavior.
function ActivatedAbilityTransformBehavior:EditorItems(parentPanel)
	local result = {}
	self:ApplyToEditor(parentPanel, result)
	self:FilterEditor(parentPanel, result)
	self:SummonEditor(parentPanel, result, { haveTargetCreature = true })
	self:OngoingEffectEditor(parentPanel, result, {transform = true})
	return result
end
