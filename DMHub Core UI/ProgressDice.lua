local mod = dmhub.GetModLoading()
function gui.ProgressDice(options)

	local progress = options.progress or 0
	options.progress = nil

	local result = {

		bgcolor = "white",
		bgimage = "panels/logo/codex.png",
		flow = "vertical",
		width = 600,
		height = 600,
		halign = "center",
		valign = "center",


		gui.Panel {

			bgcolor = "white",
			bgimage = "panels/logo/codex.png",
			flow = "vertical",
			width = "100%",
			height = string.format("%f%%", 100 - (progress * 100)),
			halign = "center",
			valign = "top",

			saturation = 0,
			floating = true,

			imageRect = { x1 = 0, y1 = progress, x2 = 1, y2 = 1 },

			progress = function (element, progress)

				element.selfStyle.height =  string.format("%f%%", 100 - (progress * 100))
				element.selfStyle.imageRect = { x1 = 0, y1 = progress, x2 = 1, y2 = 1 }
				
			end

		}




	}

	for key, value in pairs(options) do
		
		result[key] = value

	end


	return gui.Panel(result)

end

