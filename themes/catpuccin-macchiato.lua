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

theme.font                  = "Ubuntu Nerd Font 7"

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
theme.menu_submenu_icon     = themes_path .. "default/submenu.png"
theme.menu_height           = dpi(15)
theme.menu_width            = dpi(100)

-- You can use your own layout icons like this:
theme.layout_floating       = "~/Pictures/Theme/floating-muave.png"
theme.layout_tile           = "~/Pictures/Theme/tile-muave.png"
theme.layout_max            = "~/Pictures/Theme/max-muave.png"

-- Generate Awesome icon:
theme.awesome_icon          = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme            = nil

return theme
