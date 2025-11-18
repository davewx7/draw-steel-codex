local mod = dmhub.GetModLoading()


local SymbolMeanings = {
	enemy = {
		"This creature is an enemy",
		"This creature is not an enemy",
	},
	["attack.finesse"] = {
		"You are using a finesse weapon",
		"You are not using a finesse weapon",
	},
	["attack.ranged"] = {
		"You are using a ranged weapon",
		"You are not using a ranged weapon",
	},
	["attack.melee"] = {
		"You are using a melee weapon",
		"You are not using a melee weapon",
	},
	haveadvantage = {
		"You have advantage on this attack",
		"You do not have advantage on this attack",
	},
	havedisadvantage = {
		"You have disadvantage on this attack",
		"You do not have disadvantage on this attack",
	},
	["target.nexttoanotherenemy"] = {
		"The target is within 5 feet of an enemy of theirs that is not incapacitated",
		"The target is not within 5 feet of an enemy of theirs that is not incapacitated",
	},
	multiclass = {
		"You are a multiclass character",
		"You are not a multiclass character",
	},
	monoclass = {
		"You are a monoclass character",
		"You are not a monoclass character",
	},

	["attack.attribute"] = {
		"Your attack's attribute",
	},

	strengthattack = {
		"You are using a strength attack",
		"You are not using a strength attack",
	},
	
	dexterityattack = {
		"You are using a dexterity attack",
		"You are not using a dexterity attack",
	},

	constitutionattack = {
		"You are using a constitution attack",
		"You are not using a constitution attack",
	},

	intelligenceattack = {
		"You are using an intelligence attack",
		"You are not using an intelligence attack",
	},

	wisdomattack = {
		"You are using a wisdom attack",
		"You are not using a wisdom attack",
	},

	charismaattack = {
		"You are using a charisma attack",
		"You are not using a charisma attack",
	},

	yourturn = {
		"It is your turn",
		"It is not your turn",
	},
}

function GoblinScriptSymbolDocument(symbol, positive)
	local sym = SymbolMeanings[symbol]
	if sym ~= nil then
		if positive then
			return sym[1]
		else
			return sym[#sym]
		end
	end

	return symbol
end
