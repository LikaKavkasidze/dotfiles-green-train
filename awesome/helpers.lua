local awful = require("awful")
local naughty = require("naughty")

local helpers = {}
local external_screen_enabled = false

-- Change the current keyboard layout to a
-- given one by its identifier.
helpers.keyboard_layout = function(id)
    layout = "fr"

    if id == "r" then
        layout = "ru"
    elseif id == "z" then
        layout = "az"
    elseif id == "t" then
        layout = "tr"
    elseif id == "o" then
        layout = "ro"
    elseif id == "a" then
        layout = "ar"
    elseif id == "g" then
        layout = "ge"
    end

    if id == "o" then
        awful.spawn.with_shell("setxkbmap -layout ro -variant std")
    else
        awful.spawn.with_shell("setxkbmap "..layout)
    end
end

-- Volume control using PulseAudio
-- Pass a value between -100 and +100
-- Positive values increase the volume, negative values decreases it.
-- If zero is given, then mute is toggled
helpers.volume_control = function(step)
    local cmd

    if step == 0 then
        cmd = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
    else
        pactl_value = step > 0 and "+"..tostring(step).."%" or "-"..tostring(-step).."%"
        cmd = "pactl set-sink-volume @DEFAULT_SINK@ "..pactl_value
    end

    awful.spawn.with_shell(cmd)
end

-- Toggle microphone mute using PulseAudio
helpers.mute_microphone = function()
    awful.spawn.with_shell("pactl set-source-mute @DEFAULT_SOURCE@ toggle")
end

luminosity_storage = ""

-- Brightness control with X.org tools (xbacklight)
-- Pass a value between -100 and +100
-- Positive values increase the brightness, negative values decreases it.
-- If zero is given, then screen darkening is toggled
helpers.brightness_control = function(step)
    local cmd

    if step == 0 then
        awful.spawn.with_line_callback("xbacklight -get", {
            stdout = function(line)
                if line == "0" then
                    cmd = "xbacklight -set "..luminosity_storage
                else
                    luminosity_storage = line
                    cmd = "xbacklight -set 0"
                end
            end,
            stderr = function(line)
                naughty.notify { text = "ERR: "..line }
            end,
        })
    else
        xback_value = step > 0 and "inc "..tostring(step) or "dec "..tostring(-step)
        cmd = "xbacklight -"..xback_value
    end

    awful.spawn.with_shell(cmd)
end

helpers.auto_screen = function()
    -- Check if more than one screen is available
    awful.spawn.easy_async_with_shell("xrandr | grep ' connected' | wc -l", function(count_result)
        count = tonumber(count_result)

        if count > 1 then
            -- Identify the screen to use
            -- TODO: For now, we assume no more than two screens
            awful.spawn.easy_async_with_shell("xrandr | grep ' connected' | tail -n1 | cut -d' ' -f1", function(line)
                local screen = line:gsub("\n", "")

                if external_screen_enabled then
                    awful.spawn.with_shell("xrandr --output "..screen.." --off")

                    external_screen_enabled = false
                else
                    awful.spawn.with_shell("xrandr --output "..screen.." --auto")
                    awful.spawn.with_shell("xrandr --output "..screen.." --left-of eDP1")

                    external_screen_enabled = true
                end
            end)
        end
    end)
end

helpers.icon_scale = function(scale, max, value)
    local index = math.floor((value / max) * #scale)

    return scale[index]
end

return helpers
