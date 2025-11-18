local mod = dmhub.GetModLoading()

--The proficiency levels we recognize. More proficiencies can easily be added.
creature.RegisterProficiency{
	id = "none",
	text = "Not Proficient",
	multiplier = 0,
	verboseDescription = "You are not proficient in %s.",
}

creature.RegisterProficiency{
	id = "half",
	text = "Half Proficient",
	multiplier = 0.5,
	verboseDescription = "You may apply half your proficiency bonus to a skill check with %s.",
}

creature.RegisterProficiency{
	id = "proficient",
	text = "Proficient",
	multiplier = 1,
	verboseDescription = "You are proficient with %s.",
}

creature.RegisterProficiency{
	id = "expertise",
	text = "Expertise",
	multiplier = 2,
	characterSheetLabel = "E",
	verboseDescription = "You may apply double your proficiency bonus to skill checks with %s.",
}