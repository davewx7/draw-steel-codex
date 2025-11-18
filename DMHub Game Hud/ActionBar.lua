local mod = dmhub.GetModLoading()

setting{
	id = "tinyactionbar",
	text = "Expanded Action Bar",
	description = "Expanded Action Bar",
	storage = "preference",
	default = false,
	editor = "check",
}

--make sure when we load this mod the game hud gets rebuilt so it includes our new action bar.
dmhub.RebuildGameHud()

ActionBar = {

	allowTinyActionBar = true,

	hasLoadoutPanel = true,
	hasCustomizationPanel = true,
	hasMovementTypePanel = true,
	containerUIScale = 1,
	containerPageSize = 8,
	mainPanelMaxWidth = 1300,
	mainPanelHAlign = "center",
	bars = {},
	transparentBackground = false,

	--If set, the spell info tooltip is shown when the spell is clicked, not just as a transient tooltip.
	spellInfoOnClick = false,
	resourcesWithBars = false,
	largeQuantityResourceHorizontal = true,
	actionsMinWidth = 0,

	sortByDisplayOrder = false,
	hasReactionBar = true,
}
