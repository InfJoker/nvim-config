local shown = false

local function toggle_no_focus()
  local terminal = require("claudecode.terminal")
  local bufnr = terminal.get_active_terminal_bufnr()
  if bufnr and #vim.fn.win_findbuf(bufnr) > 0 then
    terminal.close()
    return true -- was visible, now closed
  else
    terminal.ensure_visible()
    return false -- was hidden, now opened
  end
end

local function open_with_keymaps()
  local closed = toggle_no_focus()
  if closed or shown then
    return
  end
  shown = true
  vim.schedule(function()
    local lines = {
      " Claude Code Keymaps  ",
      " ──────────────────── ",
      " <leader>ct  Toggle   ",
      " <leader>cf  Focus    ",
      " <leader>cs  Send (v) ",
      " <leader>cb  Buffer   ",
      " <leader>cm  Model    ",
      " <leader>ca  Accept   ",
      " <leader>cd  Deny     ",
    }
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    local win = vim.api.nvim_open_win(buf, false, {
      relative = "editor",
      anchor = "NE",
      row = 1,
      col = vim.o.columns,
      width = 22,
      height = #lines,
      style = "minimal",
      border = "rounded",
    })
    vim.wo[win].winhl = "Normal:Comment"
    vim.defer_fn(function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end, 5000)
  end)
end

local M = {
  "coder/claudecode.nvim",
  commit = "aa9a5cebebdbfa449c1c5ff229ba5d98e66bafed",
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSend",
    "ClaudeCodeAdd",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
    "ClaudeCodeSelectModel",
  },
  keys = {
    { "<leader>ct", open_with_keymaps, mode = { "n", "t" }, desc = "Claude terminal" },
    { "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude focus" },
    { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude send" },
    { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Claude buffer" },
    { "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Claude model" },
    { "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude accept" },
    { "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Claude deny" },
  },
}

M.opts = {
  terminal = {
    provider = "native",
    split_side = "right",
    split_width_percentage = 0.30,
  },
}

return M
