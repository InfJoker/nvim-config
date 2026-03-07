local M = {
  "kyazdani42/nvim-tree.lua",
  commit = "4b30847c91d498446cb8440c03031359b045e050",
  event = "VimEnter",
}

function M.config()
  local function on_attach(bufnr)
    local api = require "nvim-tree.api"
    local opts = function(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set("n", "l", api.node.open.edit, opts "Open")
    vim.keymap.set("n", "h", api.node.navigate.parent_close, opts "Close Directory")
    vim.keymap.set("n", "v", api.node.open.vertical, opts "Open: Vertical Split")
  end

  require("nvim-tree").setup {
    on_attach = on_attach,
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    renderer = {
      icons = {
        glyphs = {
          default = "\u{F4A5}",
          symlink = "\u{F482}",
          folder = {
            arrow_open = "\u{F47C}",
            arrow_closed = "\u{F460}",
            default = "\u{E5FF}",
            open = "\u{E5FE}",
            empty = "\u{F114}",
            empty_open = "\u{F115}",
            symlink = "\u{F482}",
            symlink_open = "\u{F482}",
          },
          git = {
            unstaged = "\u{F444}",
            staged = "S",
            unmerged = "\u{E727}",
            renamed = "\u{279C}",
            untracked = "U",
            deleted = "\u{F458}",
            ignored = "\u{25CC}",
          },
        },
      },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = {
        hint = "\u{F834}",
        info = "\u{F05A}",
        warning = "\u{F071}",
        error = "\u{F057}",
      },
    },
    view = {
      width = 30,
      side = "left",
    },
  }
end

return M
