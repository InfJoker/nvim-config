local M = {
  "folke/which-key.nvim",
  commit = "3aab2147e74890957785941f0c1ad87d0a44c15a",
  event = "VeryLazy",
}

function M.config()
  require("which-key").setup {}
end

return M
