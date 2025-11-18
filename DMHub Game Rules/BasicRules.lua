local mod = dmhub.GetModLoading()

--this file contains a collection of basic/core rules.

rules = {

	damageTypes = {
		'acid', 'bludgeoning', 'cold', 'fire', 'force', 'lightning', 'necrotic', 'piercing', 'poison', 'psychic', 'radiant', 'slashing', 'thunder'
	},
	damageTypesToInfo = {
	},

	alignmentIds = { "lawful good", "neutral good", "chaotic good", "lawful neutral", "true neutral", "chaotic neutral", "lawful evil", "neutral evil", "chaotic evil", "unaligned"},
	alignments = {
		["lawful good"] = {
			name = "Lawful Good",
		},
		["neutral good"] = {
			name = "Neutral Good",
		},
		["chaotic good"] = {
			name = "Chaotic Good",
		},
		["lawful neutral"] = {
			name = "Lawful Neutral",
		},
		["true neutral"] = {
			name = "True Neutral",
		},
		["chaotic neutral"] = {
			name = "Chaotic Neutral",
		},
		["lawful evil"] = {
			name = "Lawful Evil",
		},
		["neutral evil"] = {
			name = "Neutral Evil",
		},
		["chaotic evil"] = {
			name = "Chaotic Evil",
		},
		["unaligned"] = {
			name = "Unaligned",
		},
	},
}

rules.damageTypesWithAll = DeepCopy(rules.damageTypes)
rules.damageTypesWithAll[#rules.damageTypesWithAll+1] = "all"

RegisterGameType("DamageInstance")
RegisterGameType("AttackDefinition")

--Returns an Attack based on this definition.
function AttackDefinition.GenerateAttackInstance(self, char)

	local modifier = tonumber(self:try_get('additionalModifier', '0'))
	if modifier == nil then
		modifier = 0
	end

	local mod = 0

	if self:has_key('modifierAttr') and self.modifierAttr ~= 'none' then
		local attr = char:GetAttribute(self.modifierAttr)
		if attr ~= nil then
			mod = attr:Modifier()
			modifier = modifier + mod

		end
	end

	if self.proficiency then
		modifier = modifier + char:ProficiencyBonus()
	end

	local damageInstances
	if self:has_key('damage') then
		damageInstances = { self }
	else
		damageInstances = self:try_get('damageInstances', {})
	end

	local resultDamageInstances = {}
	for i,instance in ipairs(damageInstances) do
		local damage = instance.damage
		if mod > 0 then
			damage = damage .. '+' .. mod
		elseif mod < 0 then
			damage = damage .. mod
		end

		resultDamageInstances[#resultDamageInstances+1] = DamageInstance.new{
			damage = damage,
			damageType = instance.damageType,
		}
	end


	return Attack.new{
		iconid = self.iconid,
		name = self.name,
		range = self:try_get('range', 5),
		hit = modifier,
		damageInstances = resultDamageInstances,
		details = self:try_get('details'),
		attackTriggeredAbility = self:try_get("attackTriggeredAbility"),
		--damage = dmhub.NormalizeRoll(damage),
		--damageType = self.damageType,
	}

end

--ResistanceEntry type.
--   nonmagic: (optional) boolean.
--   damageType: from rules.damageTypes enum
--   apply: from ResistanceEntry.types enum
--   keywords: a table of {string: true} that contains keywords that this matches to.
--   dr (optional): number that is valid when damageType == 'Damage Reduction' or damageType == 'Percent Reduction'
RegisterGameType("ResistanceEntry")

ResistanceEntry.source = "Innate"
ResistanceEntry.nonmagic = false
ResistanceEntry.resistanceTypes = {'Resistant', 'Vulnerable', 'Immune'}
ResistanceEntry.types = {'Resistant', 'Vulnerable', 'Immune', 'Damage Reduction', 'Percent Reduction'}
ResistanceEntry.dr = 0
ResistanceEntry.stacks = false
                


--wrapper for Locs from the engine.
RegisterGameType("Loc")

function Loc.Create(loc)
	return Loc.new{
		_tmp_loc = loc,
	}
end

Loc.lookupSymbols = {
	datatype = function(c)
		return "location"
	end,

	debuginfo = function(c)
		return string.format("loc: %d, %d", c._tmp_loc.x, c._tmp_loc.y)
	end,

	self = function(c)
		return c
	end,

	x = function(c)
		return c._tmp_loc.x
	end,

	y = function(c)
		return c._tmp_loc.y
	end,

	floor = function(c)
		return c._tmp_loc.floor
	end,

	valid = function(c)
		return c._tmp_loc.valid and c._tmp_loc.isOnMap
	end,

	distance = function(c)
		return function(other)
            if type(other) == "function" then
                other = other("self")
            end

			if type(other) ~= "table" or rawget(other, "_tmp_loc") == nil then
				if type(other) == "table" and rawget(other, "typeName") ~= nil then
					local otherToken = dmhub.LookupToken(other)
					if otherToken == nil then
						return 0
					end
					return other:Distance(c._tmp_loc)
				end
				return 0
			end

			return c._tmp_loc:DistanceInTiles(other._tmp_loc)*MeasurementSystem.NativeSystem().tileSize
		end
	end,
}

Loc.helpSymbols = {
	__name = "location",
	__sampleFields = {"x", "y", "distance"},

	x = {
		name = "x",
		type = "number",
		desc = "The x co-ordinate of the location",
	},

	y = {
		name = "y",
		type = "number",
		desc = "The y co-ordinate of the location",
	},

	floor = {
		name = "Floor",
		type = "number",
		desc = "The floor the location is on.",
	},

	valid = {
		name = "Valid",
		type = "boolean",
		desc = "True if the location is valid and within the map bounds."
	},

	distance = {
		name = "Distance",
		type = "function",
		desc = "The distance from another location or a creature in tiles.",
	},

}