local M = {
  "goolord/alpha-nvim",
  event = "VimEnter",
  commit = "a9d8fb72213c8b461e791409e7feabb74eb6ce73",
}

function M.config()
  local alpha = require "alpha"
  local dashboard = require "alpha.themes.dashboard"

  -- Try to use shader-art for the header; fall back to static ASCII art
  local shader_ok, shader_art = pcall(require, "shader-art")
  local shader_element = nil
  if shader_ok then
    shader_element = shader_art.make_element { width = 69, height = 16, fps = 15 }
  end

  if not shader_element then
    dashboard.section.header.val = {
      [[                               __]],
      [[  ___     ___    ___   __  __ /\_\]],
      [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\]],
      [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \]],
      [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
      [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    }
  end

  dashboard.section.buttons.val = {
    dashboard.button("f", "\u{F0C5} " .. " Find file", ":Telescope find_files <CR>"),
    dashboard.button("e", "\u{F15B} " .. " New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("p", "\u{F401} " .. " Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
    dashboard.button("s", "\u{F017} " .. " Sessions", ":AutoSession search<CR>"),
    dashboard.button("r", "\u{F1DA} " .. " Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("t", "\u{F002} " .. " Find text", ":Telescope live_grep <CR>"),
    dashboard.button("c", "\u{F013} " .. " Config", ":e $MYVIMRC <CR>"),
    dashboard.button("q", "\u{F011} " .. " Quit", ":qa<CR>"),
  }
  local function footer()
    return "Hello World!"
  end

  dashboard.section.footer.val = footer()

  dashboard.section.footer.opts.hl = "Type"
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Keyword"

  -- If shader element available, inject it into the layout replacing the header
  if shader_element then
    require "alpha.term" -- register the terminal layout element handler
    local layout = {
      { type = "padding", val = 2 },
      shader_element,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }
    dashboard.opts.layout = layout
  end

  dashboard.opts.opts.noautocmd = true
  alpha.setup(dashboard.opts)
end

return M
