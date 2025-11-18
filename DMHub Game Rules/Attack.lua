local mod = dmhub.GetModLoading()

--This file contains rules for how attacks work. Note that to be used, an attack
--is put into an activated ability which will trigger the attack.
--attacks are fairly constrained in what they do, just implementing core rules for attacking. Most flexibility
--is performed inside of the activated ability which will modify what exactly happens when the attack is used.

-- name: name of attack
-- iconid: string
-- range: string
-- damageInstances: list of {damage -> string, flags = { string -> bool }, damageMagical -> bool, damageType -> string}
-- hit: string
-- isSpell: if this attack is a spell.
-- hands: (optional) number of hands used for this attack.
-- offhand: (optional) bool
-- weapon: (optional) underlying weapon.
-- modifiers: (optional) list of CharacterModifiers that apply when using this attack.
-- melee: (optional) bool, tells us definitively if this is melee vs ranged. Prefer to have this on attacks but we will try to work it out if not.
-- meleeRange: (optional) number, if this is set then this attack is considered a melee attack if it is being made at this range or less. This is for thrown weapons.
-- attrid: (optional) the string attribute id that is used for this attack.
-- consumeAmmo: (optional) map of {itemid -> quantity} to consume
-- outOfAmmo: (optional) no available ammo.
-- properties: (optional) table of WeaponProperty objects
RegisterGameType("Attack")

Attack.isSpell = false
Attack.hands = 1

function Attack.DescribeDamage(self)
	local result = ''
	for i,damageInstance in ipairs(self.damageInstances) do
		if i > 1 then
			result = result .. ' plus '
		end

		result = result .. damageInstance.damage .. ' ' .. cond(damageInstance:try_get('damageMagical'), 'magical ', '') .. damageInstance.damageType
	end
	return result
end

function Attack.DescribeDamageRoll(self)
	local result = ''
	for i,damageInstance in ipairs(self.damageInstances) do
		result = result .. damageInstance.damage .. ' [' .. cond(damageInstance:try_get('damageMagical'), 'magical ', '') .. damageInstance.damageType .. '] '
	end
	return result
end

function Attack.DescribeHitRoll(self)
	if self.hit > 0 then
		return GameSystem.BaseAttackRoll .. '+' .. self.hit
	elseif self.hit == 0 then
		return GameSystem.BaseAttackRoll
	else
		return GameSystem.BaseAttackRoll .. self.hit
	end
end

function Attack.RangeNormal(self)
	if self.range == nil then
		return 5
	end

	if string.find(self.range, '^%d+$') then
		dmhub.Debug('RANGE MATCH FIRST')
		return tonumber(self.range) or 5
	end

	local result
	_,_,result,_ = string.find(self.range, '^(%d+)/(%d+)$')

	return tonumber(result) or 5
end

function Attack.RangeDisadvantage(self)
	if self.range == nil then
		return nil
	end

	local result
	local short
	_,_,short,result = string.find(self.range, '^(%d+)/(%d+)$')

	if result ~= nil and tonumber(short) >= tonumber(result) then
		return nil
	end

	return tonumber(result)
end

function Attack:IsRangedOrMelee()
	return self:has_key("melee") and self:has_key("meleeRange")
end

function Attack:IsRanged(attackerToken, defenderToken)
	if self:has_key("melee") then
		if self:has_key("meleeRange") and attackerToken ~= nil and defenderToken ~= nil and attackerToken:DistanceInFeet(defenderToken) > self.meleeRange then
			--outside of melee range so this becomes a ranged attack.
			return true
		end

		return not self.melee
	end

	local rangeNormal = self:RangeNormal()
	local rangeDisadvantage = self:RangeDisadvantage()
	return rangeNormal > 30 or (rangeDisadvantage ~= nil and rangeDisadvantage > rangeNormal)
end

function Attack:GetDamageTypesSet()
	local result = {}
	for k,d in pairs(self.damageInstances) do
		result[#result+1] = d.damageType
	end

	return StringSet.new{
		strings = result
	}
end

--The fields in attack made available to GoblinScript.
Attack.lookupSymbols = {
	self = function(c)
		return c
	end,

	name = function(c)
		return c.name
	end,

	debuginfo = function(c)
		return string.format("attack: %s", c.name)
	end,

	datatype = function(c)
		return "attack"
	end,

	ammo = function(attack)
		return attack:has_key("weapon") and attack.weapon:HasProperty("ammo")
	end,

	thrown = function(attack)
		return attack:has_key("weapon") and attack.weapon:HasProperty("thrown")
	end,

	finesse = function(attack)
		return attack:has_key("weapon") and attack.weapon:HasProperty("finesse")
	end,
	
	meleerange = function(attack)
		if attack:has_key("meleeRange") then
			return attack.meleeRange
		end

		if attack:IsRanged() then
			return 0
		end
		return 5
	end,

	melee = function(attack)
		return not attack:IsRanged()
	end,

	ranged = function(attack)
		return attack:IsRanged()
	end,

	range = function(attack)
		return attack:RangeNormal()
	end,

	spell = function(attack)
		return attack.isSpell
	end,

	attribute = function(attack)
		local attrInfo = creature.attributesInfo[attack:try_get("attrid", "")]
		if attrInfo ~= nil then
			return attrInfo.description
		end

		return nil
	end,

	magical = function(attack)
		for k,d in pairs(attack.damageInstances) do
			if d.damageMagical then
				return true
			end
		end

		return false
	end,

	damagetypes = function(attack)
		return attack:GetDamageTypesSet()
	end,

	hands = function(attack)
		return attack.hands
	end,

	properties = function(attack)
		local result = {}

		if attack:has_key("properties") then
			for k,v in pairs(attack.properties) do
				local propertyInfo = WeaponProperty.Get(k)
				if propertyInfo ~= nil then
					result[#result+1] = propertyInfo.name
				end
			end
		end

		return StringSet.new{
			strings = result,
		}
	end,

	propertyvalue = function(attack)
		return function(key)
			if not attack:has_key("properties") then
				return 0
			end

			local keyLower = string.gsub(string.lower(key), "%s", "")
			for k,v in pairs(attack.properties) do
				local propertyInfo = WeaponProperty.Get(k)
				if propertyInfo ~= nil and string.gsub(string.lower(propertyInfo.name), "%s", "") == keyLower then
					if type(v) == "table" then
						return v.value or 1
					end

					return 1
				end
			end


			return 0
		end
	end,
}

--The GoblinScript documentation for attacks.
Attack.helpSymbols = {
	__name = "attack",
	__sampleFields = {"finesse", "melee"},
	name = {
		name = "Name",
		type = "text",
		desc = "The name of the attack."
	},
	finesse = {
		name = "Finesse",
		type = "boolean",
		desc = "True if this attack is being made with a finesse weapon.",
	},
	meleerange = {
		name = "Melee Range",
		type = "number",
		desc = "The range within which the attack is considered a melee attack. Thrown weapons used outside of this range will be used as ranged weapons.",
		seealso = {"Melee", "Thrown", "Ranged"},
		examples = {"self.Distance(target) <= Melee Range"},
	},
	melee = {
		name = "Melee",
		type = "boolean",
		desc = "True if this attack is a melee attack. Weapons that can optionally be thrown are considered melee, not ranged. Use Melee Range to check if they are being thrown.",
		seealso = {"Ranged"},
	},
	ranged = {
		name = "Ranged",
		type = "boolean",
		desc = "True if this attack is a ranged attack. Weapons that can optionally be thrown are considered melee, not ranged. Use Melee Range to check if they are being thrown.",
		seealso = {"Melee"},
	},
	range = {
		name = "Range",
		type = "number",
		desc = "The range of the attack in feet.",
		seealso = {"Ranged"},
	},
	attribute = {
		name = "Attribute",
		type = "text",
		desc = "The attribute used to modify this attack.",
	},
	spell = {
		name = "Spell",
		type = "boolean",
		desc = "True if this is a spell attack. All attacks are either weapon attacks or spell attacks.",
	},
	magical = {
		name = "Magical",
		type = "boolean",
		desc = "True if this attack does magical damage.",
	},
	damagetypes = {
		name = "Damage Types",
		type = "set",
		desc = "The set of damage types this attack does.",
		examples = {'Attack.Damage Types Has "Fire"'},
	},
	hands = {
		name = "Hands",
		type = "number",
		desc = "The number of hands used for this attack. Normally 1, but 2 for two handed weapons or versatile weapons being used with two hands.",
		examples = {"Attack.Hands = 2"},
	},

	properties = {
		name = "Properties",
		type = "set",
		desc = "The names of any properties the attack has.",
		examples = {'Attack.Properties Has "Finesse"'}
	},

	propertyvalue = {
		name = "Property Value",
		type = "function",
		desc = "A function which provides the value of the property given to it.",
		examples = {'Attack.PropertyValue("Fatal")'},

	},
}
