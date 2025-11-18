local mod = dmhub.GetModLoading()

--- @class ModalDialogArgs:PanelArgs
--- @param title string
--- @param buttons {text: string, click: nil|function, escapeActivates: boolean}[]
--- @param classes: nil|string[]

--- Create a modal dialog
--- @param options ModalDialogArgs
function GameHud:ModalDialog(options)

	local styles = {
		{
			selectors = {'modal-dialog'},
			halign = "center",
			valign = "center",
			bgcolor = 'white',
		},
		{
			selectors = {'main-panel'},
			width = '100%-32',
			height = '100%-32',
			flow = 'vertical',
			halign = 'center',
			valign = 'center',
		},
		{
			selectors = {'client-panel'},
			width = '100%',
			height = '100%-100',
		},
		{
			selectors = {'button-panel'},
			width = '100%',
			height = 60,
			flow = 'horizontal',
			valign = 'bottom',
		},
		{
			selectors = {'title'},
			width = 'auto',
			height = 'auto',
			color = 'white',
			halign = 'center',
			valign = 'top',
			fontSize = 28,
		},

		{
			selectors = {'input'},
			width = '80%',
			halign = 'center',
			priority = 20,
			height = 34,
			valign = 'center',
		},
		{
			selectors = {'checkbox'},
			height = 30,
			width = 'auto',
		},
		{
			selectors = {'checkbox-label'},
			fontSize = 26,
		},
		Styles.Form,
		Styles.Panel,
	}

	options.width = nil
	options.height = nil

	local title = gui.Label{
		classes = {'title'},
		text = options.title,
	}

	options.title = nil


	local dialogPanel

	local buttonElements = {}

	local buttons = options.buttons or { { text = "Close" } }
	options.buttons = nil

	for _,button in ipairs(buttons) do
		buttonElements[#buttonElements+1] =
			gui.PrettyButton{
				text = button.text,
				escapeActivates = button.escapeActivates,
				escapePriority = EscapePriority.EXIT_MODAL_DIALOG,
				width = 200,
				height = 50,
				halign = 'right',
				hmargin = 8,
				events = {
					click = function(element)
						if button.click then
							button.click()
						end

						dialogPanel:FireEvent("close")
					end,
				}
			}
	end

	local buttonPanel = gui.Panel{
		classes = {'button-panel'},
		children = buttonElements,
	}

	local classes = options.classes or {}
	if type(classes) == "string" then
		classes = {classes}
	end

	classes[#classes+1] = "client-panel"
	options.classes = classes

	local clientPanel = gui.Panel(options)

	local mainPanel = gui.Panel{
		classes = {'main-panel'},
		children = {
			title,
			clientPanel,
			buttonPanel,
		}
	}

	dialogPanel = gui.Panel{
		classes = {'framedPanel'},

		width = options.width or 1024,
		height = options.height or 768,

		styles = styles,

		close = function(element)
			gamehud:CloseModal()
		end,

		children = {
			mainPanel,
		},
	}

	gamehud:ShowModal(dialogPanel)
	return dialogPanel

end
