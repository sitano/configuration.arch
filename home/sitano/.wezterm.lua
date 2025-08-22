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
config.font_size = 16
config.command_palette_font_size = 16
config.char_select_font_size = 16
config.window_frame = {
  font      = font,
  font_size = 32,
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
    mods = 'ALT',
    action = wezterm.action.ActivateTabRelative(-1)
  },
  {
    key = 'RightArrow',
    mods = 'ALT',
    action = wezterm.action.ActivateTabRelative(1)
  },
  {
    key = ']',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection 'Next',
  },
  {
    key = '[',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection 'Prev',
  },
  {
    key = 'UpArrow',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection 'Next',
  },
  {
    key = 'DownArrow',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection 'Prev',
  },
  {
    key = 'w',
    mods = 'ALT',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
  {
    key = 'v',
    mods = 'SHIFT|ALT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'h',
    mods = 'SHIFT|ALT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'r',
    mods = 'SHIFT|ALT', 
    action = wezterm.action.RotatePanes 'Clockwise',
  },
  {
    key = 't',
    mods = 'ALT',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'LeftArrow',
    mods = 'ALT|SHIFT',
    action = wezterm.action.MoveTabRelative(-1),
  },
  {
    key = 'RightArrow',
    mods = 'ALT|SHIFT',
    action = wezterm.action.MoveTabRelative(1),
  }
}

for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = wezterm.action.ActivateTab(i - 1),
  })
  -- F1 through F8 to activate that tab
  table.insert(config.keys, {
    action = wezterm.action.ActivateTab(i - 1),
  })
end

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
