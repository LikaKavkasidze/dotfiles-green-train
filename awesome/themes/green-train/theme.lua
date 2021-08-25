-----------------------------------
--   Green train awesome theme   --
-----------------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local themes_path = os.getenv("HOME") .. "/.config/awesome/themes/"

local theme = {}

-- Color palette
theme.primary_color_d = "#3c3025"
theme.primary_color   = "#584b39"
theme.primary_color_l = "#72624a"
theme.primary_color_w = "#ededed"

theme.secondary_color_d = "#a54629"
theme.secondary_color_l = "#d08670"

theme.accent_color = "#699f49"

-- Fonts used
theme.font      = "Fira Mono 10"
theme.icon_font = "FiraMono Nerd Font 12"
theme.sans_font = "Fira Sans 10"

-- Awesome-specific variables
theme.bg_normal   = theme.primary_color_d
theme.bg_focus    = theme.secondary_color_d
theme.bg_urgent   = theme.secondary_color_l
theme.bg_minimize = theme.bg_normal

theme.fg_normal   = theme.primary_color_w
theme.fg_focus    = theme.primary_color_w
theme.fg_urgent   = theme.fg_focus
theme.fg_minimize = theme.fg_focus

theme.titlebar_bg_normal = theme.primary_color_d
theme.titlebar_bg_focus  = theme.primary_color

theme.taglist_font        = theme.icon_font
theme.taglist_fg_empty    = theme.primary_color_l
theme.taglist_fg_focus    = theme.fg_focus
theme.taglist_fg_occupied = theme.fg_normal

theme.hotkeys_modifiers_fg = theme.secondary_color_l

theme.useless_gap  = dpi(0)
theme.border_width = dpi(0)

theme.menu_submenu_icon = themes_path .. "green-train/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- Define the images to load
theme.titlebar_close_button_normal = themes_path.."green-train/titlebar/close_normal.svg"
theme.titlebar_close_button_focus  = themes_path.."green-train/titlebar/close_focus.svg"

theme.titlebar_minimize_button_normal = themes_path.."green-train/titlebar/minimize_normal.svg"
theme.titlebar_minimize_button_focus  = themes_path.."green-train/titlebar/minimize_focus.svg"

theme.titlebar_maximized_button_normal_inactive = themes_path.."green-train/titlebar/maximized_normal.svg"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."green-train/titlebar/maximized_focus_inactive.svg"
theme.titlebar_maximized_button_normal_active = themes_path.."green-train/titlebar/maximized_normal.svg"
theme.titlebar_maximized_button_focus_active  = themes_path.."green-train/titlebar/maximized_focus_active.svg"

theme.wallpaper = os.getenv("HOME") .. "/Images/Wallpapers/Green1.jpg"

-- Define layout icons
theme.layout_floating  = themes_path.."green-train/layouts/floatingw.png"
theme.layout_tile = themes_path.."green-train/layouts/tilew.png"
theme.layout_tilebottom = themes_path.."green-train/layouts/tilebottomw.png"

-- Default icon theme
theme.icon_theme = nil

return theme