local wibox = require("wibox")
local beautiful = require("beautiful")
local lain = require("lain")
local helpers = require("../helpers")

local battery_scale = { "", "", "", "", "", "", "", "", "", "" }

local battery_image = wibox.widget {
    text = "",
    align = "center",
    font = beautiful.icon_font,
    widget = wibox.widget.textbox
}

battery_text = lain.widget.bat({
    pspath = "/sys/class/power_supply/",
    notify = "off",
    settings = function()
        local icon = ""

        if type(bat_now.perc) == "number" then
            icon = helpers.icon_scale(battery_scale, 100, bat_now.perc)
        end

        if bat_now.status == "Charging" then
            icon = ""
        end

--        if bat_now.status == "Discharging" then
--            if tonumber(bat_now.perc) <= 30 then
--                naughty.notify({
--                    preset = naughty.config.presets.normal,
--                    title  = "Batterie faible",
--                    text   = "Penser à brancher l'alimentation !",
--                })
--            end
--        end

        battery_image.text = icon

        widget:set_markup(bat_now.perc.."%")
    end,
    widget = wibox.widget {
        align = "center",
        widget = wibox.widget.textbox
    }
})

local battery_widget = wibox.widget {
    battery_image,
    battery_text.widget,
    layout = wibox.layout.fixed.vertical
}

return battery_widget
