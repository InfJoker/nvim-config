local M = {
  "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  commit = "737cf6c657898d0c697311d79d361288a1343d50"
}

function M.config()
  require("nvim-web-devicons").setup {
    override = {
      zsh = {
        icon = "",
        color = "#428850",
        cterm_color = "65",
        name = "Zsh",
      },
    },
    color_icons = true,
    default = true,
  }
end

return M
