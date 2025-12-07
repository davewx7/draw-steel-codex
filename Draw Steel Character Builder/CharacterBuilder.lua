--- Character Sheet Builder  building a character step by step
--- Functions standalone or plugs in to CharacterSheet
CharacterBuilder = RegisterGameType("DSBuilder")

CharacterBuilder.ROOT_CHAR_SHEET_CLASS = "characterSheetHarness"

CharacterBuilder.STRINGS = {}
CharacterBuilder.STRINGS.ANCESTRY = {}
CharacterBuilder.STRINGS.ANCESTRY.OVERVIEW = [[
Fantastic peoples inhabit the worlds of Draw Steel. Among them are devils, dwarves, elves, time raiders--and of course humans, whose culture and history dominates many worlds.

Ancestry describes how you were born. Culture (part of Chapter 4: Background) describes how you grew up. If you want to be a wode elf who was raised in a forest among other wode elves, you can do that! If you want to play a wode elf who was raised in an underground city of dwarves, humans, and orcs, you can do that too!

Your hero is one of these folks! The fantastic ancestry you choose bestows benefits that come from your anatomy and physiology. This choice doesn't grant you cultural benefits, such as crafting or lore skills, though. While many game settings have cultures made of mostly one ancestry, other cultures and worlds have a cosmopolitan mix of peoples.]]

--[[
    Register selectors - analagous to tabs on the old builder
]]

CharacterBuilder.Selectors = {}

function CharacterBuilder.ClearBuilderTabs()
    CharacterBuilder.Selectors = {}
end

function CharacterBuilder.RegisterSelector(selector)
    CharacterBuilder.Selectors[#CharacterBuilder.Selectors+1] = selector
    table.sort(CharacterBuilder.Selectors, function(a,b) return a.ord < b.ord end)
end

--[[
    Utilities
]]

function CharacterBuilder._inCharSheet(element)
    return element:FindParentWithClass(CharacterBuilder.ROOT_CHAR_SHEET_CLASS) ~= nil
end

function CharacterBuilder._sortItemsByName(items)
    table.sort(items, function(a,b) return a.name < b.name end)
    return items
end

function CharacterBuilder._toArray(t)
    local a = {}
    for _,item in pairs(t) do
        a[#a+1] = item
    end
    return a
end
