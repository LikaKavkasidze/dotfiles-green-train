local gears = require("gears")
local awful = require("awful")
local helpers = require("helpers")
local hotkeys_popup = require("awful.hotkeys_popup")

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    awful.key({ modkey, "Shift"   }, "n", function() awful.tag.add("", { screen = awful.screen.focused(), layout = awful.layout.suit.tile }) end,
              {description = "add a tag", group = "tag"}),
    awful.key({ modkey, "Shift"   }, "d",
        function()
            local t = awful.screen.focused().selected_tag
            if not t then return end
            t:delete()
        end,
              {description = "delete current tag", group = "tag"}),

    awful.key({ modkey,           }, "j", function () awful.client.focus.byidx( 1) end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k", function () awful.client.focus.byidx(-1) end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(editor_cmd) end,
              {description = "open a text editor", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "i", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "i", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },   "r", function () awful.util.spawn("rofi -show run")
    end,
              {description = "run rofi prompt", group = "launcher"}),

    awful.key({ modkey },   "c", function () awful.util.spawn("rofi -show calc -modi calc -no-sort")
    end,
              {description = "run rofi calculator prompt", group = "launcher"}),

    awful.key({ modkey },   "p", function() awful.util.spawn("rofi-pass") end,
              {description = "run rofi pass prompt", group = "launcher"}),

    awful.key({ modkey },   "w",
        function()
            awful.util.spawn("alacritty -e 'ncmpcpp'")
        end,
    {description = "run NCMPCPP", group = "launcher"}),

    -- Language layouts switch
    awful.key({ modkey, "Shift"   }, "a",
        function()
            helpers.keyboard_layout("a")
        end,
        {description = "switch keyboard to Arabic", group = "keyboard"}),
    awful.key({ modkey, "Shift"   }, "z",
        function()
            helpers.keyboard_layout("z")
        end,
        {description = "switch keyboard to Azerbaijani", group = "keyboard"}),
    awful.key({ modkey, "Shift"   }, "r",
        function()
            helpers.keyboard_layout("r")
        end,
        {description = "switch keyboard to Russian", group = "keyboard"}),
    awful.key({ modkey, "Shift"   }, "t",
        function()
            helpers.keyboard_layout("t")
        end,
        {description = "switch keyboard to Turkish", group = "keyboard"}),
    awful.key({ modkey, "Shift"   }, "o",
        function()
            helpers.keyboard_layout("o")
        end,
        {description = "switch keyboard to Romanian", group = "keyboard"}),
    awful.key({ modkey, "Shift"   }, "g",
        function()
            helpers.keyboard_layout("g")
        end,
        {description = "switch keyboard to Georgian", group = "keyboard"}),
    awful.key({ modkey, "Shift"   }, "space",
        function()
            helpers.keyboard_layout("f")
        end,
        {description = "switch keyboard to French", group = "keyboard"}),

    -- Power function
    awful.key({ modkey, "Control"   }, "p",
    function()
        awful.spawn.with_shell("shutdown now")
    end,
    {description = "turn off the computer", group = "power"}),

    awful.key({ modkey, "Control"   }, "s",
    function()
        awful.spawn.with_shell("systemctl suspend")
    end,
    {description = "suspend the computer", group = "power"}),

    -- Special keys
    awful.key({ }, "XF86AudioMute",
        function()
            helpers.volume_control(0)
        end,
        {description = "(un)mute headphones", group = "volume"}),
    awful.key({ }, "XF86AudioLowerVolume",
        function()
            helpers.volume_control(-5)
        end,
        {description = "lower volume", group = "volume"}),
    awful.key({ }, "XF86AudioRaiseVolume",
        function()
            helpers.volume_control(5)
        end,
        {description = "raise volume", group = "volume"}),
    awful.key({ }, "XF86AudioMicMute",
        function()
            helpers.mute_microphone()
        end,
        {description = "(un)mute microphone", group = "volume"}),
    awful.key({ }, "XF86MonBrightnessDown",
        function()
            helpers.brightness_control(-5)
        end,
        {description = "decrease brightness", group = "screen"}),
    awful.key({ }, "XF86MonBrightnessUp",
        function()
            helpers.brightness_control(5)
        end,
        {description = "increase brightness", group = "screen"}),
    awful.key({ }, "XF86Explorer",
        function()
            helpers.auto_screen()
        end,
        {description = "automatically configure screens", group = "screen"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c:move_to_screen()            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}
