local mod = dmhub.GetModLoading()

RegisterGameType("ActivatedAbilityRemoveCreatureBehavior", "ActivatedAbilityBehavior")

ActivatedAbility.RegisterType
{
	id = 'remove_creature',
	text = 'Remove Creature',
	createBehavior = function()
		return ActivatedAbilityRemoveCreatureBehavior.new{
		}
	end
}

ActivatedAbilityRemoveCreatureBehavior.summary = 'Remove Creatures'
ActivatedAbilityRemoveCreatureBehavior.dropsLoot = false
ActivatedAbilityRemoveCreatureBehavior.leavesCorpse = false
ActivatedAbilityRemoveCreatureBehavior.waitForAbilitiesToFinish = true

function ActivatedAbilityRemoveCreatureBehavior:SummarizeBehavior(ability, creatureLookup)
	return "Remove Creatures"
end

function ActivatedAbilityRemoveCreatureBehavior:DropLoot(token)
	local objects = assets:GetObjectsWithKeyword("corpse")

	if #objects == 0 then
		return
	end

	local inventory = DeepCopy(token.properties:try_get("inventory", {}))

	--drop the held items as well.
	local equip = token.properties:Equipment()
	local sharesSeen = {}
	for slotid,itemid in pairs(equip) do
		
		--make sure this isn't a shared slot.
		local metaslot = token.properties:EquipmentMetaSlot(slotid)
		local seen = false
		if metaslot.share ~= nil then
			if sharesSeen[metaslot.share] then
				seen = true
			else
				sharesSeen[metaslot.share] = true
			end
		end

		if not seen then
			local entry = inventory[itemid]
			if entry == nil then
				entry = {quantity = 0}
				inventory[itemid] = entry
			end

			entry.quantity = entry.quantity + 1
		end
	end

	local haveItems = false
	for _,itemid in pairs(inventory) do
		haveItems = true
		break
	end

	if haveItems == false then
		for k,v in pairs(token.properties:try_get("currency", {})) do
			if v ~= nil and v > 0 then
				haveItems = true
				break
			end
		end
	end

	if haveItems == false then
		return
	end



	local floor = game.GetFloor(token.floorid)

	local newObj = floor:CreateLocalObjectFromBlueprint{
		assetid = objects[1].id,
	}

	newObj.scale = newObj.scale * token.radiusInTiles * 2
	newObj.x = token.pos.x
	newObj.y = token.pos.y

	local loot = {
		["@class"] = "ObjectComponentLoot",
		destroyOnEmpty = true,
		instantLoot = false,
		locked = false,
		properties = {
			__typeName = "loot",
			inventory = inventory,
			currency = DeepCopy(token.properties:try_get("currency", {}))
		}
	}

	newObj:AddComponentFromJson("LOOT", loot)

	newObj:Upload()
end

local g_damageTypeToDescription = {
    acid = {"dissolved", "melted", "corroded"},
    cold = {"frozen"},
    corruption = {"rotted away", "withered", "consumed", "defiled"},
    fire = {"incinerated", "reduced to ashes", "immolated", "burned to a crisp"},
    holy = {"smitten", "purified", "cleansed in holy light", "struck down"},
    lightning = {"electrocuted", "struck down", "fried"},
    poison = {"poisoned", "envenomed"},
    psychic = {"mentally obliterated", "mind-shattered"},
    sonic = {"pulverized"},
    untyped = {"slain", "cut down", "felled", "killed"},
    collide = {"crushed", "smashed"},
    fall = {"forced over an edge", "thrown to their death", "hurled to their death"}
}

function ActivatedAbilityRemoveCreatureBehavior:LeaveCorpse(token)
    local objects = assets:GetObjectsWithKeyword("corpse")

    if #objects == 0 then
        return
    end

    local floor = game.GetFloor(token.floorid)
    if floor == nil then
        return
    end

    local newObj = floor:CreateLocalObjectFromBlueprint{
        assetid = objects[1].id,
    }

    newObj.scale = newObj.scale * token.radiusInTiles * 2
    newObj.x = token.pos.x
    newObj.y = token.pos.y

    newObj:AddComponentFromJson("CORPSE", {
        ["@class"] = "ObjectComponentCorpse",
        properties = {
            __typeName = "CorpseComponent",
            charid = token.charid,
        }
    })

    local message = creature.GetTokenDescription(token)

    if message ~= nil and message ~= "(unknown token)" then
        local q = dmhub.initiativeQueue
        local round = nil
        if q ~= nil and (not q.hidden) then
            round = q.round
        end

        local damageType = token.properties:try_get("_tmp_lastdamagetype", nil)
        local damageOptions = g_damageTypeToDescription[damageType or "untyped"] or g_damageTypeToDescription.untyped
        local damageDescription = damageOptions[math.random(1, #damageOptions)]

        message = string.format("%s, %s", message, damageDescription)

        local attackerName = nil
        local attacker = token.properties:try_get("_tmp_lastattacker", nil)
        print("ATTACKER:: LAST =", attacker, damageType)
        if attacker ~= nil then
            if type(attacker) == "function" then
                attacker = attacker("self")
            end
            attacker = dmhub.LookupToken(attacker)
            print("ATTACKER:: LOOKUP =", attacker ~= nil, attacker ~= nil and attacker.valid)
            if attacker ~= nil and attacker.valid then
                print("ATTACKER:: NAME =", attacker.name)
                attackerName = attacker.name
            end
        end

        if attackerName ~= nil then
            message = string.format("%s by %s", message, attackerName)
        end

        if round ~= nil then
            message = string.format("%s on round %d", message, round)
        end


        newObj:AddComponentFromJson("MESSAGE", {
            ["@class"] = "ObjectComponentHoverText",
            text = message,
        })
        
    end

    newObj:Upload()
end

function ActivatedAbilityRemoveCreatureBehavior:Cast(ability, casterToken, targets, options)
    local charids = {}
    for i,target in ipairs(targets) do

        local targetPasses = true
        if self.waitForAbilitiesToFinish then
            local castInfo = ActivatedAbility.CurrentCastInfo() or {}
            castInfo.activity = "reaping"

            local startTime = dmhub.Time()
            while startTime < dmhub.Time() + 120 and ActivatedAbility.CountActiveCasts{reaping = true} > 0 do
                coroutine.yield(0.1)
            end

            if dmhub.Time() > startTime + 0.5 then
                --wait a little longer just to clear up any forced moves/etc
                coroutine.yield(0.5)
            end

            castInfo.activity = nil

            --make sure we still pass the filter.
            local filterTarget = trim(self.filterTarget)
            if filterTarget ~= "" then
                local symbols = table.shallow_copy(options.symbols or {})
                symbols.target = target.token.properties
                symbols.caster = casterToken.properties
                symbols.targetnumber = i
                symbols.numberoftargets = #targets

                targetPasses = GoblinScriptTrue(dmhub.EvalGoblinScriptDeterministic(filterTarget, target.token.properties:LookupSymbol(symbols), 1, "Filter remove creature"))
            end
        end

        if targetPasses then
            if self.dropsLoot then
                self:DropLoot(target.token)
            end

            if self.leavesCorpse then
                self:LeaveCorpse(target.token)
            end

            if target.token.properties:IsMonster() then
                target.token.despawned = true
            else
                charids[#charids+1] = target.token.charid
            end
        end

    end

    if #charids > 0 then
        game.DeleteCharacters(charids)
    end
    ability:CommitToPaying(casterToken, options)
end



function ActivatedAbilityRemoveCreatureBehavior:EditorItems(parentPanel)
	local result = {}
	self:ApplyToEditor(parentPanel, result)
	self:FilterEditor(parentPanel, result)

	result[#result+1] = gui.Check{
		text = "Drops Loot",
		value = self.dropsLoot,
		change = function(element)
			self.dropsLoot = element.value
		end,
	}

    result[#result+1] = gui.Check{
        text = "Leaves Corpse Object",
        value = self.leavesCorpse,
        change = function(element) 
            self.leavesCorpse = element.value
        end,
    }

    result[#result+1] = gui.Check{
        text = "Wait for Abilities to Finish",
        value = self.waitForAbilitiesToFinish,
        change = function(element) 
            self.waitForAbilitiesToFinish = element.value
        end,
    }

	return result
end

--- @class CorpseComponent
CorpseComponent = RegisterGameType("CorpseComponent")

CorpseComponent.charid = "none"

function CorpseComponent:Respawn(obj)
    local token = dmhub.GetCharacterById(self.charid)
    if token ~= nil then
        if obj ~= nil then
            local x = round(obj.x)
            local y = round(obj.y)
            if token.loc.x ~= x or token.loc.y ~= y then
                token:ChangeLocation(core.Loc{x = x, y = y, floorIndex = obj.floorIndex}:WithGroundLevelAltitude())
            end
        end
        token.despawned = false
    end
end

function CorpseComponent:DeadCreatureToken()

    local result = dmhub.GetCharacterById(self.charid)
    print("Dead::", self.charid, result)
    return result
end