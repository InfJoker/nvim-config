local M = {
  "lukas-reineke/indent-blankline.nvim",
  commit = "d28a3f70721c79e3c5f6693057ae929f3d9c0a03",
  event = "BufReadPre",
}

M.main = "ibl"
M.opts = {
  indent = { char = "▏" },
  scope = { enabled = true },
  exclude = {
    buftypes = { "terminal", "nofile" },
    filetypes = { "help", "packer", "NvimTree" },
  },
}

return M
