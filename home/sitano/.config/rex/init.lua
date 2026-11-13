rex.bind("cmd+up", "client.tab.previous")
rex.bind("cmd+down", "client.tab.next")
rex.bind("ctrl+up", "client.tab.previous")
rex.bind("ctrl+down", "client.tab.next")

rex.bind("shift+cmd+up", "client.tab.move", { direction = "backward" })
rex.bind("shift+cmd+down", "client.tab.move", { direction = "forward" })
rex.bind("ctrl+shift+up", "client.tab.move", { direction = "backward" })
rex.bind("ctrl+shift+down", "client.tab.move", { direction = "forward" })

rex.bind("ctrl+t", "client.tab.new")
rex.bind("cmd+w", "pane.close")

rex.bind("shift+cmd+v", "pane.split", { direction = "right" })
rex.bind("ctrl+shift+v", "pane.split", { direction = "right" })
rex.bind("shift+cmd+h", "pane.split", { direction = "down" })
rex.bind("ctrl+shift+h", "pane.split", { direction = "down" })

rex.bind("cmd+left", "pane.focus", { direction = "left" })
rex.bind("cmd+right", "pane.focus", { direction = "right" })
rex.bind("ctrl+left", "pane.focus", { direction = "left" })
rex.bind("ctrl+right", "pane.focus", { direction = "right" })
rex.bind("ctrl+]", "pane.focus_next")
rex.bind("ctrl+[", "pane.focus_previous")

rex.bind("cmd+1", "client.tab.goto", { index = 1 })
rex.bind("cmd+2", "client.tab.goto", { index = 2 })
rex.bind("cmd+3", "client.tab.goto", { index = 3 })
rex.bind("cmd+4", "client.tab.goto", { index = 4 })
rex.bind("cmd+5", "client.tab.goto", { index = 5 })
rex.bind("cmd+6", "client.tab.goto", { index = 6 })
rex.bind("cmd+7", "client.tab.goto", { index = 7 })
rex.bind("cmd+8", "client.tab.goto", { index = 8 })
rex.bind("ctrl+1", "client.tab.goto", { index = 1 })
rex.bind("ctrl+2", "client.tab.goto", { index = 2 })
rex.bind("ctrl+3", "client.tab.goto", { index = 3 })
rex.bind("ctrl+4", "client.tab.goto", { index = 4 })
rex.bind("ctrl+5", "client.tab.goto", { index = 5 })
rex.bind("ctrl+6", "client.tab.goto", { index = 6 })
rex.bind("ctrl+7", "client.tab.goto", { index = 7 })
rex.bind("ctrl+8", "client.tab.goto", { index = 8 })

-- Select the "boot" session, or create it with top + a shell if it does not exist.
local function exec(cmd, cwd)
  return { block = { flavor = "com.superlogical.terminal.shell", options = { command = cmd, cwd = cwd } } }
end

-- Run a command line through the login shell, so ~, quotes and PATH work.
local function cmd(line)
  return { os.getenv("SHELL") or "/bin/zsh", "-lc", line }
end

rex.action{
  name = "boot",
  title = "Open boot session",
  run = function(ctx)
    for _, s in ipairs(rex.call("session.list").sessions or {}) do
      if s.label == "boot" then
        return rex.client.queue("session.select", { session_id = s.session_id })
      end
    end

    local home = os.getenv("HOME")
    local projects = home .. "/Projects"
    local created = rex.call("session.create", {
      label = "boot",
      initial_windows = {
        { window_label = "monitor", layout = { split = { direction = "horizontal", ratio = 0.6,
            before = exec({ "top" }, home), after = exec(nil, home) } } },
        { window_label = "vpn", layout = exec(cmd("echo '# sudo openfortivpn -c ...'; exec $SHELL -l"), projects) },
        { window_label = "ray", layout = exec(cmd("echo '# wireproxy -c ...'; exec $SHELL -l"), projects) },
        { window_label = "caf", layout = exec(cmd("echo '# caffeinate -im'; exec $SHELL -l"), projects) },
        { window_label = "repowise", layout = exec(cmd("REPOWISE_EMBEDDER=mock " .. home .. "/.local/bin/repowise serve --no-open"), projects) },
      },
    })

    return rex.client.queue("session.select", { session_id = created.session_id })
  end,
}
