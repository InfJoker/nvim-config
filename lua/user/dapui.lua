local M = {
  "rcarriga/nvim-dap-ui",
  commit = "cf91d5e2d07c72903d052f5207511bf7ecdb7122",
  event = "VeryLazy",
  dependencies = {
    {
      "mfussenegger/nvim-dap",
      commit = "a9d8cb68ee7184111dc66156c4a2ebabfbe01bc5",
      event = "VeryLazy",
    },
  },
}

function M.config()
  require("dapui").setup {
    expand_lines = true,
    icons = { expanded = "\u{F0DD}", collapsed = "\u{F0DA}", circular = "\u{F110}" },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.33 },
          { id = "breakpoints", size = 0.17 },
          { id = "stacks", size = 0.25 },
          { id = "watches", size = 0.25 },
        },
        size = 0.33,
        position = "right",
      },
      {
        elements = {
          { id = "repl", size = 0.45 },
          { id = "console", size = 0.55 },
        },
        size = 0.27,
        position = "bottom",
      },
    },
    floating = {
      max_height = 0.9,
      max_width = 0.5, -- Floats will be treated as percentage of your screen.
      border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
  }

  vim.fn.sign_define("DapBreakpoint", { text = "\u{F188}", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
end

return M
