local ssu = require "::/gui/main/stylesheetutil.lua"

function data()
    local result = {}
    local a = ssu.makeAdder(result)

    a("R::LineGroupsTable Table::Header", {
        visibility = "none",
    })

    -- Avoid column spacing caused by the hidden header.
    a("R::LineGroupsTable Table::Header TextView", {
        margin = { 0, 0, 0, 0 },
    })

    a("R::LineGroupCell TextView", {
        margin = { 0, 0, 0, 0 },
        padding = { 0, 1, 0, 1 },
    })

    local colors = api.gui.genericRep.get(
        api.gui.genericRep.find("::/gui/main/default_colors.gres")
    ).data

    a("R::LineGroupsTable", {
        backgroundImage1 = {
            fileName = "::/gui/entity_window/design/card_surface.tga",
            horizontal = { 0, 6, 26, 32 },
            vertical = { 0, 6, 26, 32 },
        },
        borderImage = {
            fileName = "::/gui/entity_window/design/card_contour.tga",
            horizontal = { 0, 6, 26, 32 },
            vertical = { 0, 6, 26, 32 },
        },
        backgroundColor1 = colors.BaseMedium,
        borderColor = colors.BaseVeryLight,
        padding = { 1, 1, 1, 1 },
        size = { 400, 235 },
    })

    return result
end