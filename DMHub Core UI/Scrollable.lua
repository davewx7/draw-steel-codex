local mod = dmhub.GetModLoading()

function gui.ScrollablePanel(args)

	local m_virtualChildren = args.virtualChildren or {}
	args.virtualChildren = nil

	local m_resultPanel

	local params = {
		flow = "vertical",
		hideObjectsOutOfScroll = true,
		debugLogging = true,
		vscroll = true,
		scroll = function(element)
			local y = math.min(1, math.max(0, 1 - element.vscrollPosition))
		end,
	}

	for k,v in pairs(args) do
		params[k] = v
	end

	local data = params.data or {}
	params.data = data

	local RefreshChildren = function()
		local children = {}

		for i,v in ipairs(m_virtualChildren) do
			children[i] = v.panel or gui.Panel{
				data = {
					child = nil,
				},

				width = "100%",
				height = "auto",
				minHeight = v.estimatedHeight,

				expose = function(element)
					if element.data.child == nil then
						element.data.child = m_virtualChildren[i].create()
						element.children = {element.data.child}
					end
				end,
			}

			v.panel = children[i]
		end

		m_resultPanel.children = children
	end

	data.AddVirtualChild = function(child)
		m_virtualChildren[#m_virtualChildren+1] = child
		RefreshChildren()
	end

	data.SetVirtualChildren = function(children)
		m_virtualChildren = children
		RefreshChildren()
	end

	m_resultPanel = gui.Panel(params)

	RefreshChildren()

	return m_resultPanel
end
