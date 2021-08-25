local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local menu_buttons = gears.table.join(
    awful.button({ }, 3, function()
                            awful.menu.client_list({ theme = { width = 300, font = beautiful.sans_font } })
                        end),
    awful.button({ }, 4, function ()
                            awful.client.focus.byidx(1)
                        end),
    awful.button({ }, 5, function ()
                            awful.client.focus.byidx(-1)
                        end))

local menu = wibox.widget {
    {
        {
            {
                text = "",
                font = beautiful.icon_font,
                forced_height = 16,
                align = "center",
                widget = wibox.widget.textbox
            },
            layout = wibox.layout.fixed.vertical,
        },
        top  = 4,
        bottom = 4,
        right = 2,
        widget = wibox.container.margin
    },
    bg = beautiful.accent_color,
    widget = wibox.container.background
}

menu:buttons(menu_buttons)

return menu