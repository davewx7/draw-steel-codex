local mod = dmhub.GetModLoading()

RegisterGameType("SpellcastingFeature")

SpellcastingFeature.id = "Custom"
SpellcastingFeature.name = "Spellcasting"
SpellcastingFeature.attr = "int"
SpellcastingFeature.level = 1
SpellcastingFeature.refreshType = "prepared" --known or prepared.
SpellcastingFeature.spellbook = false
SpellcastingFeature.spellbookSize = 0
SpellcastingFeature.spellbookSpells = {}
SpellcastingFeature.spellLists = {}
SpellcastingFeature.dc = 10
SpellcastingFeature.attackBonus = 2
SpellcastingFeature.maxSpellLevel = 1
SpellcastingFeature.numKnownCantrips = 0
SpellcastingFeature.numKnownSpells = 0
SpellcastingFeature.knownCantrips = {}
SpellcastingFeature.knownSpells = {}
SpellcastingFeature.memorizedSpells = {}
SpellcastingFeature.grantedSpells = {} --list of spellid's granted to this feature.
SpellcastingFeature.upcastingType = "cast" --none, cast, prepared
SpellcastingFeature.canUseSpellSlots = true

SpellcastingFeature.ritualCasting = false


SpellcastingFeature.RefreshTypeOptions = {
    {
        id = "prepared",
        text = "Prepared",
    },
    {
        id = "known",
        text = "Known",
    },
}

SpellcastingFeature.UpcastingOptions = {
    {
        id = "cast",
        text = "When casting",
    },
    {
        id = "prepared",
        text = "When preparing",
    },
    {
        id = "none",
        text = "None",
    },
}


--some utils for encoding/decoding spellcasting spellids with levels included.

function SpellcastingFeature.EncodeSpellId(spellid, level)
    if level == nil then
        return spellid
    end
    return string.format("level:%s:%s", tostring(level), spellid)
end

function SpellcastingFeature.DecodeSpellId(spellid)
    if string.starts_with(spellid, "level:") == false then
        return spellid, nil
    end

    local level, id = string.match(spellid, "level:(%d+):(.+)")
    if level == nil then
        return spellid, nil
    end
    return id, tonumber(level)
end