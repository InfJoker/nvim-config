local M = {
  "rmagatti/auto-session",
  commit = "62437532b38495551410b3f377bcf4aaac574ebe",
  lazy = false,
  keys = {
    { "<leader>ss", "<cmd>AutoSession search<cr>", desc = "Search sessions" },
    { "<leader>sa", "<cmd>AutoSession save<cr>", desc = "Save session" },
    { "<leader>sd", "<cmd>AutoSession delete<cr>", desc = "Delete session" },
  },
}

M.opts = {
  auto_restore = false,
  suppressed_dirs = { "~/", "/tmp", "/" },
  pre_save_cmds = { "NvimTreeClose" },
}

return M
