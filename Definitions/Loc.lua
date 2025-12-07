--- @class Loc 
--- @field west any 
--- @field east any 
--- @field north any 
--- @field south any 
--- @field withCurrentFloor any 
--- @field isValidFloor boolean 
--- @field x any 
--- @field y any 
--- @field floor any 
--- @field altitude any 
--- @field xyfloorOnly any 
--- @field xyOnly any 
--- @field isOnMap any 
--- @field withGroundAltitude any 
--- @field valid any 
--- @field point2 any 
--- @field point3 any 
--- @field str string 
Loc = {}

--- Deserialize
--- @param dict any
--- @return nil
function Loc:Deserialize(dict)
	-- dummy implementation for documentation purposes only
end

--- Equals
--- @param other any
--- @return boolean
function Loc:Equals(other)
	-- dummy implementation for documentation purposes only
end

--- DistanceInTiles
--- @param other any
--- @return number
function Loc:DistanceInTiles(other)
	-- dummy implementation for documentation purposes only
end

--- DistanceInFeet
--- @param other any
--- @return number
function Loc:DistanceInFeet(other)
	-- dummy implementation for documentation purposes only
end

--- dir
--- @param x number
--- @param y number
--- @return any
function Loc:dir(x, y)
	-- dummy implementation for documentation purposes only
end

--- WithAltitude
--- @param alt number
--- @return any
function Loc:WithAltitude(alt)
	-- dummy implementation for documentation purposes only
end

--- FloorDifference
--- @param loc any
--- @return number
function Loc:FloorDifference(loc)
	-- dummy implementation for documentation purposes only
end

--- WithGroundLevelAltitude
--- @return any
function Loc:WithGroundLevelAltitude()
	-- dummy implementation for documentation purposes only
end

--- LocsInRadius
--- @param radius number
--- @return any
function Loc:LocsInRadius(radius)
	-- dummy implementation for documentation purposes only
end
