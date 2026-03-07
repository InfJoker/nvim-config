local M = {
  "briones-gabriel/darcula-solid.nvim",
  commit = "d950b9ca20096313c435a93e57af7815766f3d3d",
  dependencies = {{"rktjmp/lush.nvim"},},
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
}

M.name = "darcula-solid"
function M.config()
  local status_ok, _ = pcall(vim.cmd.colorscheme, M.name)
  if not status_ok then
    return
  end
end

return M
