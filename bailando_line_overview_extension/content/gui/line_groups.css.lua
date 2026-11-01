local color_util = require "::/gui/main/color_util.tl"
local ssu = require "::/gui/main/stylesheetutil.lua"

function data()
	local result = {}
	local a = ssu.makeAdder(result)
	local colorDefault = api.gui.genericRep.get(api.gui.genericRep.find("::/gui/main/default_colors.gres")).data
	local transparency = api.gui.genericRep.get(api.gui.genericRep.find("::/gui/main/transparency.gres")).data
	local lvmSectionSmallMaxHeight = 240
	local lvmSectionDistance = 6

	-- Match the base LineManager card and LineAndDepotListEntry styles.

	a([[R::GroupsOverviewSection]], {
		size = { -1, lvmSectionSmallMaxHeight },
	})

	a([[R::GroupsOverviewSection]], {
		backgroundImage1 = {
			fileName = "::/gui/entity_window/design/card_surface.tga",
			horizontal = { 0, 6, 26, 32 },
			vertical = { 0, 6, 26, 32 }
		},
		borderImage = {
			fileName = "::/gui/entity_window/design/card_contour.tga",
			horizontal = { 0, 6, 26, 32 },
			vertical = { 0, 6, 26, 32 }
		},
		borderColor = colorDefault.BaseVeryLight,
	})

	a([[R::GroupsOverviewSection]], {
		backgroundColor1 = colorDefault.BaseMedium,
	})

	a([[R::GroupsOverviewSection]], {
		padding = { 1, 1, 1, 1 },
		margin = { 0, 0, 0, 0 },
	})

	a([[R::GroupsOverviewSection]], {
		margin = { 0, 0, lvmSectionDistance, 0 },
	})

	a([[!input-controller R::GroupsOverviewSection:hover]], {
		borderColor = colorDefault.AccentLight,
	})

	a([[#menu.management R::GroupCell Button]], {
		borderColor = colorDefault.Invisible,
		backgroundColor1 = colorDefault.Invisible,
	})

	a([[#menu.management R::GroupCell Button]], {
		transitionPropertyDuration = {},
	})

	a([[#menu.management R::GroupCell Button ImageView]], {
		transitionPropertyDuration = {},
	})

	a([[R::GroupCell Button!row]], {
		gravity = { 0, 0.5 },
		padding = { 0, 0, 0, 0 },
		margin = { 0, 0, 0, 0 },
		backgroundColor1 = colorDefault.Invisible,
		borderColor = colorDefault.Invisible,
		size = { 490, 20 },
	})

	a([[R::GroupCell Button!row Button::Layout]], {
		gravity = { -1, -1 },
	})

	a([[R::GroupCell Button!row Button::Layout > *]], {
		innerSpacing = { 0, 0 },
	})

	a([[R::GroupCell Button!row Button::Layout > BoxLayout]], {
		gravity = { -1, 0.5 },
	})

	a([[R::GroupCell Button!row!selected]], {
		backgroundColor = color_util.withTransparencyRaw(colorDefault.NeutralLight, transparency.High),
	})

	a([[R::GroupCell Button!row:hover]], {
		backgroundColor = color_util.withTransparencyRaw(colorDefault.NeutralLight, transparency.VeryHigh),
	})

	a([[R::GroupCell Button!row!selected:hover]], {
		backgroundColor = color_util.withTransparencyRaw(colorDefault.NeutralLight, transparency.Medium),
	})

	a([[R::GroupsOverviewSection Table::TableLayout Button]], {
		padding = { 0, 0, 0, 0 },
		margin = { 1, 1, 1, 1 },
	})

	return result
end
