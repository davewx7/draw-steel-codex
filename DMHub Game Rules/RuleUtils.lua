local mod = dmhub.GetModLoading()

GameRules = {}


function GameRules.TokenIncapacitated(token)
	if token.properties == nil then
		return false
	end

	return token.properties:CurrentHitpoints() <= 0
end

function GameRules.TokenNearEnemies(token)
	local nearbyTokens = token:GetNearbyTokens()
	for i,nearby in ipairs(nearbyTokens) do
		if nearby.properties ~= creature and (not nearby:IsFriend(token)) and (not GameRules.TokenIncapacitated(nearby)) then
			return true
		end
	end

	return false
end
