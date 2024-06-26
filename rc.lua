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

require("mickey")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

awful.spawn.with_shell("/home/bp/Scripts/autostart.sh")

-- {{{ User Function definitions
-- this will close all clients on all tags and screens

function close_all_open_clients()
    for _, open_client in ipairs(client.get()) do
        open_client:kill()
    end
end

-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/catpuccin-macchiato.lua")

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
browser = "firefox"
clipboardmanager = "xfce4-clipman-history"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual",      terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart",     awesome.restart },
    { "quit",        function() awesome.quit() end },
}

mymainmenu = awful.menu({
    items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal }
    }
})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

-- {{{ Helper function for quitmenu
myquitmenu = {
    { "Log Out", function() awesome.quit() end,
        menubar.utils.lookup_icon("/usr/share/icons/Papirus-Dark/24x24/apps/system-log-out.svg")
    },
    { "Reboot", "systemctl reboot",
        menubar.utils.lookup_icon("/usr/share/icons/Papirus-Dark/24x24/apps/system-reboot.svg") },
    { "Close All", function() close_all_open_clients() end,
        menubar.utils.lookup_icon("/usr/share/icons/Papirus-Dark/24x24/apps/system-suspend.svg") },
    { "Shutdown", "systemctl poweroff",
        menubar.utils.lookup_icon("/usr/share/icons/Papirus-Dark/24x24/apps/system-shutdown.svg") },
}

m_theme = {
    border_width = 2,
    border_color = '#c6a0f6',
    height = 30,
    width = 160,
    font = "Ubuntu Nerd Font 8"
}

quitpopup = awful.menu({ items = myquitmenu, theme = m_theme })
-- this closes the popup when mouse leaves
quitpopup:get_root().wibox:connect_signal("mouse::leave", function()
    quitpopup:hide()
end)

local function quitmenu()
    s = awful.screen.focused()
    m_coords = {
        x = s.geometry.x + (s.workarea.width - 170),
        y = 30
    }
    quitpopup:show({ coords = m_coords })
end

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- {{{ Wibar
mytextclock = wibox.widget.textclock("%H:%M", 60)
myclockicon = wibox.container.margin(
    wibox.widget {
        image = '/usr/share/icons/Papirus-Dark/24x24/apps/clock.svg',
        resize = true,
        widget = wibox.widget.imagebox,
    },
    0, 5, 2, 2)
mycalicon = wibox.container.margin(
    wibox.widget {
        image = '/usr/share/icons/Papirus-Dark/24x24/apps/calendar.svg',
        resize = true,
        widget = wibox.widget.imagebox,
    },
    0, 5, 2, 2)
mytextcal = wibox.widget.textclock("%a %d.%m.%y", 60)
myspacer = wibox.widget.textbox(" ")

myquitbtn = wibox.container.margin(
    wibox.widget {
        image  = '/usr/share/icons/Papirus-Dark/24x24/apps/system-shutdown.svg',
        resize = true,
        widget = wibox.widget.imagebox,
    },
    5, 2, 2, 2)
myquitbtn:connect_signal("button::press", function() quitmenu() end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end)
-- awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
-- awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

systemtray = wibox.widget.systray()
local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")

awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    }

    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        -- Left widgets
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.container.margin(
                batteryarc_widget({
                    font = "Hack 9",
                    show_current_level = true,
                    notification_position = 'top_left'
                }),
                3, 3, 3, 3),
            myspacer,
            systemtray,
            s.mypromptbox,
            s.mytasklist,
        },
        -- Middle widget
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.container.margin(
                s.mylayoutbox,
                3, 10, 3, 3),
            s.mytaglist,
        },
        -- Right widgets
        {
            layout = wibox.layout.fixed.horizontal,
            myspacer,
            mycalicon,
            mytextcal,
            myspacer,
            myclockicon,
            mytextclock,
            myquitbtn,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end)
))
-- awful.button({}, 4, awful.tag.viewnext),
-- awful.button({}, 5, awful.tag.viewprev)
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(

-- Destroy all notifications
    awful.key({ "Control" }, "space", function()
        naughty.destroy_all_notifications()
    end, { description = "destroy all notifications", group = "hotkeys" }),

    -- Show help
    awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),

    -- Tag browsing
    awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
    awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
    awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

    -- By-direction client focus
    awful.key({ modkey }, "j", function()
        -- awful.client.focus.global_bydirection("down")
        awful.client.focus.byidx(1)
        if client.focus then
            client.focus:raise()
        end
    end, { description = "focus next client", group = "client" }),
    awful.key({ modkey }, "k", function()
        awful.client.focus.byidx(-1)
        if client.focus then
            client.focus:raise()
        end
    end, { description = "focus previous client", group = "client" }),
    awful.key({ modkey }, "h", function()
        awful.screen.focus_relative(-1)
        if client.focus then
            client.focus:raise()
        end
    end, { description = "focus previous screen", group = "screen" }),
    awful.key({ modkey }, "l", function()
        awful.screen.focus_relative(1)
        if client.focus then
            client.focus:raise()
        end
    end, { description = "focus next screen", group = "screen" }),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function()
        awful.client.swap.byidx(1)
    end, { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function()
        awful.client.swap.byidx(-1)
    end, { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),

    -- Show/hide wibox
    awful.key({ modkey, "Shift" }, "b", function()
        for s in screen do
            s.mywibox.visible = not s.mywibox.visible
            if s.mybottomwibox then
                s.mybottomwibox.visible = not s.mybottomwibox.visible
            end
        end
    end, { description = "toggle wibox (top bar)", group = "awesome" }),

    -- swap screens

    awful.key({ modkey, "Shift" }, "o", function()
        local c = awful.screen.focused().get_clients()
        for cCount = 1, #c do
            c[cCount]:move_to_screen()
        end
        awful.screen.focus_relative(1)
    end, { description = "swap screens", group = "screen" }),

    -- Standard program
    awful.key({ modkey, "Shift" }, "Return", function()
        awful.spawn(terminal)
    end, { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Control" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),

    awful.key({ modkey }, "Tab", function()
        awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),

    awful.key({ modkey, "Control" }, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal("request::activate", "key.unminimize", { raise = true })
        end
    end, { description = "restore minimized", group = "client" }),

    -- User programs
    awful.key({ modkey }, "q", function()
        awful.spawn(browser)
    end, { description = "run browser", group = "launcher" }),

    awful.key({ modkey }, "c", function()
        awful.spawn(clipboardmanager)
    end, { description = "run clipboard manager", group = "launcher" }),

    -- Default
    -- rofi
    awful.key({ modkey }, "space", function()
        awful.spawn("rofi -combi-modi -show drun")
    end, { description = "show rofi", group = "launcher" }),

    -- Prompt
    awful.key({ modkey }, "r", function()
        awful.spawn("rofi -show run")
    end, { description = "run prompt", group = "launcher" }),

    awful.key({ modkey }, "w", function()
        awful.spawn("rofi -show window")
    end, { description = "run prompt", group = "launcher" }),

    awful.key({ modkey }, "b", function()
        awful.spawn(
            "rofi -show firefox_bookmarks -modi 'firefox_bookmarks:/home/bp/Scripts/rofi/rofi_firefox_bookmarks.sh'")
    end, { description = "search firefox bookmarks", group = "launcher" })
)

clientkeys = gears.table.join(
    awful.key({ modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),

    awful.key({ modkey, "Shift" }, "f", function()
        awful.client.floating.toggle()
    end, { description = "toggle floating", group = "client" }),

    awful.key({ modkey, "Shift" }, "q", function(c)
        c:kill()
    end, { description = "close", group = "client" }),

    awful.key(
        { modkey, "Control" },
        "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),

    awful.key({ modkey }, "Return", function(c)
        c:swap(awful.client.getmaster())
    end, { description = "promote focused to master", group = "client" }),

    awful.key({ modkey }, "o", function(c)
        c:move_to_screen()
    end, { description = "move to screen", group = "client" }),

    awful.key({ modkey }, "t", function(c)
        c.ontop = not c.ontop
    end, { description = "toggle keep on top", group = "client" }),

    -- awful.key({ modkey }, "n", function(c)
    --   -- The client currently has the input focus, so it cannot be
    --   -- minimized, since minimized clients can't have the focus.
    --   c.minimized = true
    -- end, { description = "minimize", group = "client" }),

    awful.key({ modkey }, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, { description = "(un)maximize", group = "client" }),

    awful.key({ modkey, "Control" }, "m", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                        -- move view to tag where cliet was sent
                        -- tag:view_only()
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",   -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "Qalculate-gtk",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
                "Gnome-calculator"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },
    {
        rule_any = { type = { "normal", "dialog", "popup" } },
        properties = { placement = awful.placement.centered },
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
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


-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Should prevent garbage collector to get filled up with time
collectgarbage("setpause", 160)
collectgarbage("setstepmul", 400)

gears.timer.start_new(10, function()
    collectgarbage("step", 20000)
    return true
end)
