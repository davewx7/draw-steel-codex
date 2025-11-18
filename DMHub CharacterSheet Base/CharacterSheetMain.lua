local mod = dmhub.GetModLoading()

RegisterGameType("CharacterSheet")

if rawget(CharacterSheet, "instance") and CharacterSheet.instance.valid then
	CharacterSheet.instance:DestroySelf()
end

CharacterSheet.instance = false

--entry point from engine to create character sheet.
function CreateCharacterSheet(info)

	local sheet
	sheet = CharSheet.CreateCharacterSheet{
		close = function(element)
			sheet:SetClass("collapsed", true)
		end,
		destroy = function(element)
			if element == CharacterSheet.instance then
				CharacterSheet.instance = false
			end
		end,
	}

	CharacterSheet.instance = sheet

	gamehud.mainDialogPanel:AddChild(sheet)
	return sheet
end

dmhub.RefreshCharacterSheet()