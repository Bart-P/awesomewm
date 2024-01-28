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

colors.dark1                = "#181926"
colors.dark2                = "#1e2030"
colors.dark3                = "#24273a"
colors.dark4                = "#363a4f"
colors.light1               = "#a5adcb"
colors.light2               = "#b8c0e0"
colors.light3               = "#cad3f5"
colors.primary              = "#c6a0f6"
colors.accent               = "#b48ead"
colors.secondary            = "#a6da95"
colors.warn                 = "#eed49f"
colors.danger               = "#ed8796"

local theme                 = {}

theme.font                  = "Ubuntu Nerd Font 8"

theme.bg_normal             = colors.dark1
theme.bg_focus              = colors.dark1
theme.bg_urgent             = colors.dark1
theme.bg_systray            = colors.dark1

theme.fg_normal             = colors.light3
theme.fg_focus              = colors.primary
theme.fg_urgent             = colors.secondary

theme.useless_gap           = dpi(4)
theme.border_width          = dpi(1)
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
