local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

return function (s)
    local datetime_widget = wibox.widget {
        {
            format = "%d/\n/%m",
            align = "center",
            id = "datetime_date",
            widget = wibox.widget.textclock
        },
        {
            format = "%H:\n:%M",
            align = "center",
            widget = wibox.widget.textclock
        },
        spacing = 5,
        layout = wibox.layout.fixed.vertical
    }

    local month_calendar = awful.widget.calendar_popup.month({
        screen = s,
        margin = 5
    })
    local date = datetime_widget:get_children_by_id("datetime_date")[1]

    month_calendar:attach(date, "br", { on_hover = false })

    return datetime_widget
end