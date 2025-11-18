local mod = dmhub.GetModLoading()

RegisterGameType("Light")

Light.size = 0.1

function Light.Create()
	return Light.new{
		color = core.Color('#ffffff'),
		radius = 8,
		innerRadius = 6,
		angle = 360,
		size = 0.1,
	}
end

function Light:RadiusInFeet()
	return self:BrightRadiusInFeet() + self:DimRadiusInFeet()
end

function Light:BrightRadiusInFeet()
	return round(self.innerRadius*5)
end

function Light:DimRadiusInFeet()
	return round(self.radius*5)
end
