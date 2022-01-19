-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- Some specific utilities for the configuration
local helpers = require("helpers")
-- Use lain widgets
local lain = require("lain")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Startup programs
helpers.keyboard_layout(0)
helpers.auto_screen()

-- Spawn music daemon
awful.spawn.with_shell("mpd")
-- Enable auto-screensaving
awful.spawn.with_shell('xss-lock /usr/bin/sflock -- -f "-misc-fixed-medium-r-semicondensed--0-0-75-75-c-0-iso8859-1" -c "WeAreInLimboThereIsNoFuture"')
-- Redshift program
awful.spawn.with_shell('redshift -l 48.8179:2.3658 -t 6000:4000 -g 0.8 -m randr')
-- }}}

-- {{{ Variable definitions
-- Try to load the local theme.
local theme = "green-train"
local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme .. "/"

if not beautiful.init(theme_dir .. "theme.lua") then
    beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua") -- a known good fallback
end

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.tile.bottom,
}
-- }}}

-- {{{ Wibar
-- Bottom widgets
battery_widget = require("modules/battery")
cpu_widget = require("modules/cpu")

keyboard_widget = {
    {
        {
            align = "center",
            widget = awful.widget.keyboardlayout
        },
        top = 9,
        bottom = 9,
        layout = wibox.container.margin
    },
    bg = beautiful.secondary_color_d,
    layout = wibox.container.background
}

mpd_widget = lain.widget.mpd({
    music_dir = "~/Musique",
    notify = "off",
    settings = function()
        local text = mpd_now.artist.." - "..mpd_now.title
        local vertical_text = ""

        if (mpd_now.state == "stop" or mpd_now.artist == "N/A") then
            text = "Nothing playing "
        end

        -- Line break at each char for vertical display
        for p, c in utf8.codes(text) do
            vertical_text = vertical_text .. utf8.char(c) .. '\n'
        end

        widget:set_markup(vertical_text)
    end,
    widget = wibox.widget {
        align = "center",
        valign = "top",
        widget = wibox.widget.textbox
    }
})

-- Define buttons used for the taglist
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
                                if client.focus then
                                    client.focus:move_to_tag(t)
                                end
                            end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
                                if client.focus then
                                    client.focus:toggle_tag(t)
                                end
                            end),
    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end)
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when the screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Define a tag list for each screen
    awful.tag({ "", "", "", "", "", "" }, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contain an icon indicating which layout we're using
    -- We need one layoutbox per screen
    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    s.task_button = require("modules/menu")
    s.datetime_widget = require("modules/datetime")(s)

    -- Create a taglist widget
    s.taglist = awful.widget.taglist {
        screen  = s,
        layout = wibox.layout.fixed.vertical,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    {
                       id     = "text_role",
                       widget = wibox.widget.textbox,
                       align = "center"
                    },
                    layout = wibox.layout.fixed.vertical,
                },
                top  = 8,
                bottom = 8,
                widget = wibox.container.margin
            },
            id     = "background_role",
            widget = wibox.container.background,
        }
    }

    -- Create the wibar
    s.right_wibox = awful.wibar {
        screen = s,
        position = "right",
        width = 32
    }

    -- Add widgets to the wibox
    s.right_wibox:setup {
        layout = wibox.layout.align.vertical,
        { -- Top widgets
            s.task_button,
            s.taglist,
            --wibox.widget.separator({
            --    orientation = "horizontal",
            --    thickness = 2
            --}),
            layout = wibox.layout.fixed.vertical
        },
        mpd_widget, -- Middle widget
        { -- Bottom widgets
            --wibox.widget.separator({
            --    orientation = "horizontal",
            --    thickness = 2
            --}),
            wibox.widget.systray(),
            cpu_widget,
            battery_widget,
            keyboard_widget,
            s.datetime_widget,
            s.layoutbox,
            spacing = 5,
            layout = wibox.layout.fixed.vertical,
        },
    }
end)
-- }}}

local keys = require("keys")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {},
        class = { "Tor Browser" },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = { "Event Tester" },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = { type = { "normal", "dialog" } },
      properties = { titlebars_enabled = true }},

    -- Except these ones
    { rule = { class = "firefox" },
      properties = { titlebars_enabled = false }}

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { size=24 }) : setup {
        { -- Left
            {
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            bottom = 2,
            top = 2,
            left = 2,
            right = 2,
            layout = wibox.container.margin
        },
        { -- Middle
            { -- Title
                align  = "center",
                font   = beautiful.sans_font,
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            {
                awful.titlebar.widget.minimizebutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal
            },
            bottom = 2,
            top = 2,
            left = 2,
            right = 2,
            layout = wibox.container.margin
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)
-- }}}
