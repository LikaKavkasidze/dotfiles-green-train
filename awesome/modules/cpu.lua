local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local cpu_widget = wibox.widget {
    {
        align = "center",
        text = "",
        font = beautiful.icon_font,
        widget = wibox.widget.textbox
    },
    {
        align = "center",
        text = "N/A°C",
        id = "cpu_textbox",
        widget = wibox.widget.textbox
    },
    layout = wibox.layout.fixed.vertical
}

-- Fetch processor temperature
awful.widget.watch('bash -c "sensors | grep \"temp1\" | head -n1 | cut -d\"+\" -f2 | cut -d\".\" -f1"', 5, function(widget, stdout)
    awesome.emit_signal("ears::cpu_t", tonumber(stdout))
end)

awesome.connect_signal("ears::cpu_t", function(value)
    if not (value == nil) then
        cpu_widget:get_children_by_id("cpu_textbox")[1]:set_markup(value.."°C")
    end
end)

return cpu_widget