-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.scrollback_lines = 100000
config.enable_scroll_bar = true
config.use_fancy_tab_bar = false
config.audible_bell = 'Disabled'

local font = wezterm.font("JetBrainsMono Nerd Font Mono")

config.font = font
config.font_size = 12
config.command_palette_font_size = 12
config.char_select_font_size = 12
config.window_frame = {
  font      = font,
  font_size = 28,
}

config.colors = {
  tab_bar = {
    background = '#f6f2ee',
    active_tab = {
      bg_color  = '#000000',
      fg_color  = '#f6f2ee',
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = '#f6f2ee',
      fg_color = '#000000',
    },
  },
}

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'

config.keys = {
  -- Turn off the default CMD-m Hide action, allowing CMD-m to
  -- be potentially recognized and handled by the tab
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = wezterm.action.ActivateTabRelative(-1)
  },
  {
    key = 'RightArrow',
    mods = 'CMD',
    action = wezterm.action.ActivateTabRelative(1)
  },
  {
    key = ']',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Next',
  },
  {
    key = '[',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Prev',
  },
  {
    key = 'UpArrow',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Next',
  },
  {
    key = 'DownArrow',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Prev',
  },
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
  {
    key = 'v',
    mods = 'SHIFT|CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'h',
    mods = 'SHIFT|CMD',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'r',
    mods = 'SHIFT|CMD', 
    action = wezterm.action.RotatePanes 'Clockwise',
  },
}

wezterm.on('update-right-status', function(window, pane)
  local date = wezterm.strftime '%Y-%m-%d %H:%M:%S'

  -- Make it italic and underlined
  window:set_right_status(wezterm.format {
    { Attribute = { Underline = 'Single' } },
    { Attribute = { Italic = false } },
    { Foreground = { Color = 'Black' } },
    { Text = date .. '   ' },
  })
end)

-- and finally, return the configuration to wezterm
return config
