local mod = dmhub.GetModLoading()

RegisterGameType("ActivatedAbilitySavingThrowBehavior", "ActivatedAbilityBehavior")


ActivatedAbilitySavingThrowBehavior.summary = 'Saving Throw'
ActivatedAbilitySavingThrowBehavior.consequenceText = ''


ActivatedAbility.RegisterType
{
	id = 'saving_throw',
	text = 'Saving Throw',
	canHaveDC = true,
	createBehavior = function()
		return ActivatedAbilitySavingThrowBehavior.new{
            dc = creature.savingThrowDropdownOptions[1].id,
		}
	end
}

function ActivatedAbilitySavingThrowBehavior:SummarizeBehavior(ability, creatureLookup)
    return "Roll Saving Throw"
end


function ActivatedAbilitySavingThrowBehavior:AccumulateSavingThrowConsequence(ability, casterToken, targets, consequences)
	local tokenids = ActivatedAbility.GetConsequenceTokenIds(self, ability, casterToken, targets)
	if tokenids == false then
		return
	end

    if self.consequenceText ~= "" then
        consequences.text = consequences.text or {}
        consequences.text[#consequences.text+1] = {
            text = self.consequenceText,
            tokens = tokenids,
        }
    end

end

function ActivatedAbilitySavingThrowBehavior:Cast(ability, casterToken, targets, options)


	if #targets == 0 then
		return
	end

	local casterName = creature.GetTokenDescription(casterToken)


	local dcaction = nil
	local tokenids = ActivatedAbility.GetTokenIds(targets)



	local dc_options = self:try_get("dc_options")
	dc_options = dc_options or {}

	dcaction = ability:RequireSavingThrowsCo(self, casterToken, tokenids, {
		id = self.dc,
		dc_options = dc_options, --self:try_get("dc_options"),
		targets = targets,
        symbols = options.symbols,
	})

	if dcaction == nil then
		--they ended up closing the saving throw dialog, meaning we just cancel the spell.
		return
		
	end

	--people rolled so we consider this to have consumed the resource.
	options.pay = true

	--check if everyone succeeded on a 'none' dc, meaning nobody will take damage
	--so we won't even roll for damage.
	if self.dcsuccess == 'none' then
		local targetsFailed = false
		for i,target in ipairs(targets) do
			local res = dcaction.info:GetTokenResult(target.token.charid)
			if res == false then
				targetsFailed = true
			end
			--local dcinfo = dcaction.info.tokens[target.token.charid]
			--if dcinfo ~= nil and dcinfo.result ~= nil and dcaction.info.checks[1].dc ~= nil and dcinfo.result < dcaction.info.checks[1].dc then
			--	targetsFailed = true
			--end
		end

		if targetsFailed == false then
			return
		end
	end

	--get rid of any targets that were removed.
	for i=#targets,1,-1 do
		local target = targets[i]
		local dcinfo = dcaction.info.tokens[target.token.charid]
		if dcinfo == nil then
			table.remove(targets, i)
		end
	end

	for i,target in ipairs(targets) do
		--new way of recording hit targets.
		local outcome = dcaction.info:GetTokenOutcome(target.token.charid)
		self:RecordOutcomeToApplyToTable(target.token, options, outcome)

		--old way of recording hit targets.
		local res = dcaction.info:GetTokenResult(target.token.charid)
		if res ~= true then
			self:RecordHitTarget(target.token, options, {failedSave = true})
		end
    end

end


function ActivatedAbilitySavingThrowBehavior:EditorItems(parentPanel)
	local result = {}
	self:ApplyToEditor(parentPanel, result)
	self:FilterEditor(parentPanel, result)
	self:DCEditor(parentPanel, result)
	return result
end
