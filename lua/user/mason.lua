local M = {
  "williamboman/mason.nvim",
  commit = "44d1e90e1f66e077268191e3ee9d2ac97cc18e65",
  cmd = "Mason",
  event = "BufReadPre",
  dependencies = {
    {
      "williamboman/mason-lspconfig.nvim",
      commit = "a324581a3c83fdacdb9804b79de1cbe00ce18550",
      lazy = true,
    },
  },
}

local settings = {
  ui = {
    border = "none",
    icons = {
      package_installed = "\u{25CD}",
      package_pending = "\u{25CD}",
      package_uninstalled = "\u{25CD}",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

function M.config()
  require("mason").setup(settings)
  require("mason-lspconfig").setup {
    ensure_installed = require("utils").servers,
    automatic_installation = true,
  }
end

return M
