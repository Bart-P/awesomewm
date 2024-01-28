---------------------------
-- Barts awesome theme --
---------------------------

local theme_assets          = require("beautiful.theme_assets")
local xresources            = require("beautiful.xresources")
local dpi                   = xresources.apply_dpi

local gfs                   = require("gears.filesystem")
local themes_path           = gfs.get_themes_dir()

local gears                 = require("gears")

local colors                = {}

colors.dark1                = "#2e3440"
colors.dark2                = "#3b4252"
colors.dark3                = "#434c5e"
colors.dark4                = "#4c566a"
colors.light1               = "#d8dee9"
colors.light2               = "#e5e9f0"
colors.light3               = "#eceff4"
colors.middle1              = "#8fbcbb"
colors.middle2              = "#88c0d0"
colors.middle3              = "#81a1c1"
colors.middle4              = "#5e81ac"
colors.primary              = "#d08770"
colors.secondary            = "#b48ead"
colors.accent               = "#a3be8c"
colors.warn                 = "#ebcb8b"
colors.danger               = "#bf616a"

local theme                 = {}

theme.font                  = "Ubuntu Nerd Font 8"

theme.bg_normal             = colors.dark1
theme.bg_focus              = colors.dark1
theme.bg_urgent             = colors.dark1
theme.bg_systray            = colors.dark1

theme.fg_normal             = colors.light1
theme.fg_focus              = colors.primary
theme.fg_urgent             = colors.secondary

theme.useless_gap           = dpi(5)
theme.border_width          = dpi(2)
theme.border_normal         = colors.dark1
theme.border_focus          = colors.primary
theme.border_marked         = colors.secondary

theme.taglist_bg_focus      = colors.primary
theme.taglist_bg_urgent     = colors.secondary
theme.taglist_fg_focus      = colors.dark1
theme.taglist_fg_occupied   = colors.accent
theme.taglist_fg_empty      = colors.dark3
theme.taglist_fg_urgent     = colors.dark3

theme.wibar_border_width    = 2
theme.wibar_border_color    = colors.dark1
theme.wibar_height          = 22

theme.tasklist_disable_icon = true
client.connect_signal("manage", function(c)
    c.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 10)
    end
end)

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height       = dpi(15)
theme.menu_width        = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
-- TODO: make the circuit wallpaper work... probably webp format does not want
-- to work... Test it out.
-- theme.wallpaper         = "~/Pictures/Walls/Blue Firewatch 2560x1600 wallpapers.png"
-- theme.wallpaper         = "~/Pictures/Walls/ciruit.png"

-- You can use your own layout icons like this:
theme.layout_floating   = "~/Pictures/LayoutIcons/layout-floating.png"
theme.layout_tile       = "~/Pictures/LayoutIcons/layout-monadtall.png"
theme.layout_max        = "~/Pictures/LayoutIcons/layout-max.png"

-- Generate Awesome icon:
theme.awesome_icon      = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme        = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
