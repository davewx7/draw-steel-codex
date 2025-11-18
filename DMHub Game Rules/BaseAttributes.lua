local mod = dmhub.GetModLoading()

creature.RegisterAttribute{
	id = "str",
	description = "Strength",
	order = 10,
}

creature.RegisterAttribute{
	id = "dex",
	description = "Dexterity",
	order = 20,
}

creature.RegisterAttribute{
	id = "con",
	description = "Constitution",
	order = 30,
}

creature.RegisterAttribute{
	id = "int",
	description = "Intelligence",
	order = 40,
}

creature.RegisterAttribute{
	id = "wis",
	description = "Wisdom",
	order = 50,
}

creature.RegisterAttribute{
	id = "cha",
	description = "Charisma",
	order = 60,
}

creature.RegisterSavingThrow{
	id = "str",
	attrid = "str",
	description = "Strength",
	order = 10,
}

creature.RegisterSavingThrow{
	id = "dex",
	attrid = "dex",
	description = "Dexterity",
	order = 20,
}

creature.RegisterSavingThrow{
	id = "con",
	attrid = "con",
	description = "Constitution",
	order = 30,
}

creature.RegisterSavingThrow{
	id = "int",
	attrid = "int",
	description = "Intelligence",
	order = 40,
}

creature.RegisterSavingThrow{
	id = "wis",
	attrid = "wis",
	description = "Wisdom",
	order = 50,
}

creature.RegisterSavingThrow{
	id = "cha",
	attrid = "cha",
	description = "Charisma",
	order = 60,
}