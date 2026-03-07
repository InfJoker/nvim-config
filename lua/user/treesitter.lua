local M = {
  "nvim-treesitter/nvim-treesitter",
  commit = "ebe76eb800d4e8df754fc96f8a7b84f578224a97",
  event = "BufReadPost",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "VeryLazy",
      commit = "1b212c2eee76d787bbea6aa5e92a2b534e7b4f8f",
    },
    {
      "nvim-tree/nvim-web-devicons",
      event = "VeryLazy",
      commit = "737cf6c657898d0c697311d79d361288a1343d50"
    },
  },
}
function M.config()
  require("nvim-treesitter").setup {
    ensure_installed = { "lua", "markdown", "markdown_inline", "bash", "python" },
  }

  -- Disable treesitter highlight for CSS (was highlight.disable = { "css" })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "css",
    callback = function(args)
      vim.treesitter.stop(args.buf)
    end,
  })

  -- Disable treesitter indent for Python and CSS (was indent.disable = { "python", "css" })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "css" },
    callback = function()
      vim.bo.indentexpr = ""
    end,
  })

  require("ts_context_commentstring").setup {
    enable_autocmd = false,
  }
end

return M
