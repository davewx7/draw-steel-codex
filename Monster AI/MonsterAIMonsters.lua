local mod = dmhub.GetModLoading()

local function GenerateStandardStrikeScoreFunction(score)
    return function(self, ai, token, ability)
        local loc = ai:FindBestMoveToUseStrike(token, ability)
        if loc ~= nil then
            return {score = score, loc = loc}
        end
    end
end

local function GenerateStandardStrikeExecuteFunction()
    return function(self, ai, token, scoringInfo, ability)
        local path = token:Move(scoringInfo.loc, {maxCost = 10000})
        ai.Sleep(0.5)

        local targets = ai:FindValidTargetsOfStrike(token, ability, scoringInfo.loc)
        ai:ExecuteAbility(token, ability, targets)
    end
end

MonsterAI:RegisterMove{
    id = "Charge and Free Strike",
    description = "Move to melee range and use a free strike, charging if possible. This is a generic move that is used if no other good options are available.",
    abilities = {"Melee Free Strike"},
    score = GenerateStandardStrikeScoreFunction(0.2),
    execute = GenerateStandardStrikeExecuteFunction(),
}

MonsterAI:RegisterMove{
    id = "Ranged Free Strike",
    description = "Move to ranged attack range and use a free strike. This is a generic move that is used if no other good options are available.",
    abilities = {"Ranged Free Strike"},
    score = GenerateStandardStrikeScoreFunction(0.2),
    execute = GenerateStandardStrikeExecuteFunction(),
}

local function GetKnockbackScoringFunction(token)
    local oursize = token.properties:CreatureSizeWhenBeingForceMoved()
    return function(targetToken)
        local size = targetToken.properties:CreatureSizeWhenBeingForceMoved()
        local result = 0.2 - targetToken.properties:Stability()*0.06

        if oursize > size then
            result = result + 0.1
        end

        return result
    end
end

MonsterAI:RegisterMove{
    id = "Knockback",
    description = "Maneuver: The generic knockback maneuver. Monsters prefer knocking back smaller and less stable targets.",
    abilities = {"Knockback"},
    score = function(self, ai, token, ability)
        --TODO: be selective about target, positioning, etc for knockback.
        local loc, score = ai:FindBestMoveToUseStrike(token, ability, GetKnockbackScoringFunction(token))
        if loc ~= nil then
            return {score = score, loc = loc}
        end
    end,
    execute = function(self, ai, token, scoringInfo, ability)
        local path = token:Move(scoringInfo.loc, {maxCost = 10000})
        ai.Sleep(0.5)
        ai:Speech(token, {"Knockback!", "I'll give you a good shove"})
        ai.Sleep(0.5)

        local targets = ai:FindValidTargetsOfStrike(token, ability, scoringInfo.loc)
        local scorefn = GetKnockbackScoringFunction(token)
        table.sort(targets, function(a,b)
            return scorefn(a.token) > scorefn(b.token)
        end)
        ai:ExecuteAbility(token, ability, targets)
    end,
}

MonsterAI:RegisterMove{
    id = "Aid Attack",
    description = "Maneuver: The generic aid attack maneuver. Will usually be less preferred than knockback unless the creature is large or stable.",
    abilities = {"Aid Attack"},
    score = function(self, ai, token, ability)
        --TODO: be selective about target, positioning, etc for knockback.
        local loc = ai:FindBestMoveToUseStrike(token, ability)
        if loc ~= nil then
            return {score = 0.1, loc = loc}
        end
    end,
    execute = function(self, ai, token, scoringInfo, ability)
        local path = token:Move(scoringInfo.loc, {maxCost = 10000})
        ai.Sleep(0.5)
        ai:Speech(token, {"Aid Attack!", "Help me get them!"})
        ai.Sleep(0.5)

        local targets = ai:FindValidTargetsOfStrike(token, ability, scoringInfo.loc)
        ai:ExecuteAbility(token, ability, targets)
    end,
}

MonsterAI:RegisterMove{
    id = "Spear Charge",
    description = "Goblin Warrior spear charge action, uses charge to get in range.",
    monsters = {"Goblin Warrior"},
    abilities = {"Spear Charge"},
    score = function(self, ai, token, ability)
        local loc = ai:FindBestMoveToUseStrike(token, ability)
        if loc ~= nil then
            return {score = 1, loc = loc}
        end
    end,
    execute = function(self, ai, token, scoringInfo, ability)
        local path = token:Move(scoringInfo.loc, {maxCost = 10000})

        local targets = ai:FindValidTargetsOfStrike(token, ability, scoringInfo.loc)
        ai:ExecuteAbility(token, ability, targets)
    end,
}

MonsterAI:RegisterMove{
    id = "Bury the Point",
    description = "Bury the Point Malice ability. This will be preferred over using Spear Charge if the target is reachable.",
    monsters = {"Goblin Warrior"},
    abilities = {"Bury the Point"},
    score = GenerateStandardStrikeScoreFunction(2),
    execute = function(self, ai, token, scoringInfo, ability)
        local path = token:Move(scoringInfo.loc, {maxCost = 10000})

        ai.Sleep(1.0)
        ai:Speech(token, {"Bury the Point!", "I'll bury this spear in you!"})
        ai.Sleep(0.5)

        local targets = ai:FindValidTargetsOfStrike(token, ability, scoringInfo.loc)
        ai:ExecuteAbility(token, ability, targets)
    end
}

MonsterAI:RegisterMove{
    id = "Shadow Chains",
    description = "Shadow Chains Malice ability. This is the Goblin Assassin's preferred ability as long as they can hit three targets.",
    monsters = {"Goblin Pirate Assassin", "Goblin Assassin"},
    abilities = {"Shadow Chains"},
    score = function(self, ai, token, ability)
        print("AI:: SCORE CALLED WITH ABILITY", ability)
        local loc,score = ai:FindBestMoveToUseStrike(token, ability)
        print("AI:: BEST LOC TO USE STRIKE", loc)
        if loc ~= nil then
            return {score = score*0.4, loc = loc} --the scoring will make it more desirable than sword stab as long as there are three targets.
        end
    end,
    execute = function(self, ai, token, scoringInfo, ability)
        local path = token:Move(scoringInfo.loc, {maxCost = 10000})
        ai.Sleep(1.0)
        ai:Speech(token, "Shadow Chains!")

        local targets = ai:FindValidTargetsOfStrike(token, ability, scoringInfo.loc)
        ai:ExecuteAbility(token, ability, targets)
    end,
}

MonsterAI:RegisterMove{
    id = "Sword Stab",
    description = "The Goblin Assassin's main ability. Used when Shadow Chains is not optimal or they can't afford the malice.",
    monsters = {"Goblin Pirate Assassin", "Goblin Assassin"},
    abilities = {"Sword Stab"},
    score = function(self, ai, token, ability)
        print("AI:: SCORE CALLED WITH ABILITY", ability)
        local loc = ai:FindBestMoveToUseStrike(token, ability)
        print("AI:: BEST LOC TO USE STRIKE", loc)
        if loc ~= nil then
            return {score = 1, loc = loc}
        end
    end,
    execute = function(self, ai, token, scoringInfo, ability)
        local path = token:Move(scoringInfo.loc, {maxCost = 10000})

        ai:Speech(token, {"Take this!", "Feel my blade!", "Die!"})
        local targets = ai:FindValidTargetsOfStrike(token, ability, scoringInfo.loc)
        ai:ExecuteAbility(token, ability, targets)
    end,
}

MonsterAI:RegisterMove{
    id = "Hide in Concealment",
    description = "Move to an available concealed location and hide.",
    monsters = {"Goblin Pirate Assassin", "Goblin Assassin"},
    abilities = {"Hide"},
    score = function(self, ai, token, ability)
        if token.properties:HasNamedCondition("Hidden") then
            return nil
        end
        local loc = ai:FindReachableConcealment()
        if loc ~= nil then
            return {score = 0.3, loc = loc}
        end

        return nil
    end,
    execute = function(self, ai, token, scoringInfo, ability)
        ai:Speech(token, {"You can't catch me!", "Now you see me, now you don't!", "Try to find me!"})
        local path = token:Move(scoringInfo.loc, {maxCost = 10000})

        ai:ExecuteAbility(token, ability, {})
    end,
}

MonsterAI:RegisterMove{
    id = "Shadow Drag",
    monsters = {"Bugbear Channeler"},
    abilities = {"Shadow Drag"},
    description = "Bugbear Channeler's Shadow Drag ability, pulls targets maximizing collision damage if possible.",
    score = function(self, ai, token, ability)
        local loc = ai:FindBestMoveToUseStrike(token, ability)
        if loc ~= nil then
            local targets = ai:FindValidTargetsOfStrike(token, ability, loc)
            return {score = math.min(#targets,2), loc = loc}
        end

        return nil
    end,
    execute = function(self, ai, token, scoringInfo, ability)
        local path = token:Move(scoringInfo.loc, {maxCost = 10000})
        ai.Sleep(0.5)
        ai:Speech(token, {"Shadow Drag!", "I'll pull you over here!"})
        ai.Sleep(0.5)

        local targets = ai:FindValidTargetsOfStrike(token, ability, scoringInfo.loc)
        ai:ExecuteAbility(token, ability, targets)
    end,
}

MonsterAI:RegisterMove{
    id = "Twist Shape",
    monsters = {"Bugbear Channeler"},
    abilities = {"Twist Shape"},
    description = "Bugbear Channeler's Twist Shape ability. This will be preferred over Shadow Drag if we can afford the malice.",
    score = function(self, ai, token, ability)
        local loc = ai:FindBestMoveToUseStrike(token, ability)
        if loc ~= nil then
            return {score = 2.5, loc = loc}
        end

        return nil
    end,
    execute = function(self, ai, token, scoringInfo, ability)
        local path = token:Move(scoringInfo.loc, {maxCost = 10000})
        ai.Sleep(0.5)
        ai:Speech(token, {"I'll warp your very existence!", "Twist Shape!"})
        ai.Sleep(0.5)

        local targets = ai:FindValidTargetsOfStrike(token, ability, scoringInfo.loc)
        ai:ExecuteAbility(token, ability, targets)
    end,
}

MonsterAI:RegisterMove{
    id = "Blistering Element",
    monsters = {"Bugbear Channeler"},
    abilities = {"Blistering Element"},
    description = "The Bugbear Channeler will run to the middle of a cluster of enemies to use this ability. It will be preferred over other abilities if it can hit at least three targets.",
    score = function(self, ai, token, ability)
        local loc, score = ai:FindBestMoveToUseBurst(token, ability)
        return {score = score*0.9, loc = loc} --this scoring will make it prefers to use drag unless it can get three heroes.
    end,
    execute = function(self, ai, token, scoringInfo, ability)
        local path = token:Move(scoringInfo.loc, {maxCost = 10000})
        ai.Sleep(0.5)
        ai:Speech(token, {"Blistering Element!", "I'll end you all!"})
        ai.Sleep(0.5)

        ai:ExecuteAbility(token, ability)
    end,
}

MonsterAI:RegisterMove{
    id = "Two Shot",
    monsters = {"Ryll"},
    abilities = {"Two Shot"},
    description = "Will position to hit two targets if possible.",
    score = GenerateStandardStrikeScoreFunction(1),
    execute = function(self, ai, token, scoringInfo, ability)
        local path = token:Move(scoringInfo.loc, {maxCost = 10000})
        local targets = ai:FindValidTargetsOfStrike(token, ability, scoringInfo.loc)
        ai.Sleep(0.5)
        if #targets >= 2 then
            ai:Speech(token, {"Two arrows notched!", "Both of you at once!"})
        else
            ai:Speech(token, {"Just one arrow today.", "Two stones, but only one bird."})
        end
        ai.Sleep(0.5)

        ai:ExecuteAbility(token, ability, targets)
    end,
}

MonsterAI:RegisterMove{
    id = "Razor Claws",
    monsters = {"Ghoul"},
    abilities = {"Razor Claws"},
    description = "Ghoul's preferred melee attack.",
    score = GenerateStandardStrikeScoreFunction(1),
    execute = GenerateStandardStrikeExecuteFunction(),
}