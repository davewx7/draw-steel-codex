local mod = dmhub.GetModLoading()

function creature:GetFollowers()
    return {}
end

function character:GetFollowers()
    return self:get_or_add("followers", {})
end

function monster:GetFollowers()
    return {}
end

function creature:IsRetainer()
    return false
end

function monster:IsRetainer()
    return self:try_get("retainer", false)
end

function creature:GetMentor()
    return
end

function creature:Retainers()
    return {}
end

function character:Retainers()
    local retainers = {}
    local followers = self:GetFollowers()

    for _, follower in ipairs(followers) do
        if follower and follower.type == "retainer" then
            local retainerToken = dmhub.GetTokenById(follower.retainerToken)
            if retainerToken ~= nil then
                retainers[#retainers + 1] = retainerToken
            end
        end
    end

    return retainers
end

function monster:GetMentor()
    local token = dmhub.LookupToken(self)
    local partyMembers = dmhub.GetCharacterIdsInParty(token.partyid) or {}

    for _, charid in pairs(partyMembers) do
        local charToken = dmhub.GetTokenById(charid)
        if charToken ~= nil then
            local followers = charToken.properties:GetFollowers()
            for _, follower in ipairs(followers) do
                if follower.retainerToken == token.charid then
                    return charToken.properties
                end
            end
        end
    end

    return
end

creature.RegisterSymbol {
    symbol = "retainer",
    lookup = function(c)
        return c:IsRetainer()
    end,
    help = {
        name = "Retainer",
        type = "boolean",
        desc = "If this creature is a retainer, this will be true.",
        seealso = {},
    },
}

creature.RegisterSymbol {
    symbol = "mentor",
    lookup = function(c)
        return c:GetMentor()
    end,
    help = {
        name = "Mentor",
        type = "creature",
        desc = "The mentor of this Retainer. Only valid if Retainer is true.",
        seealso = {},
    },
}