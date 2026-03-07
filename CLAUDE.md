# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal Neovim configuration using lazy.nvim as the plugin manager. All Lua, no Vimscript.

## Architecture

**Boot sequence** (`init.lua`): loads `options` → `keymaps` → `Lazy` → `autocommands`.

**Plugin auto-discovery**: `lua/Lazy.lua` calls `require("lazy").setup("user", ...)`, which scans every file in `lua/user/` as a plugin spec. To add a plugin, create a single `lua/user/<name>.lua` — no other file needs editing.

**LSP server list**: `lua/utils/init.lua` exports `M.servers`, a table of LSP server names. `lua/user/mason.lua` uses it for auto-install; `lua/user/lsp.lua` uses it to configure each server. Per-server settings live in `lua/settings/<server>.lua` (e.g., `lua_ls.lua`, `pyright.lua`, `clangd.lua`).

**Leader key**: Space. Set in both `lua/keymaps.lua` and `lua/Lazy.lua` (before lazy.nvim loads).

## Plugin Spec Conventions

Every plugin spec file returns a table `M` with the lazy.nvim spec fields. Most plugins use `M.config()` (imperative setup); a few use the declarative `M.opts` style:

- **`M.config()`** (majority): most plugins. Some add a `pcall` guard (toggleterm, colorscheme, lsp, dap, lualine); others call `require` directly (nvim-tree, mason, cmp, etc.)
- **`M.opts`** (declarative): telescope, claudecode, gitsigns, indentline

Both are valid lazy.nvim. Prefer `M.opts` for new plugins.

**Commit pinning**: all plugins use `commit = "<full-SHA>"` — never `version` or `tag`. When adding a plugin, fetch the latest SHA with `git ls-remote`.

## Adding a New Plugin

1. `git ls-remote https://github.com/<org>/<repo>.git HEAD` to get the commit SHA
2. Fetch the plugin's README to confirm commands, config options, and dependencies
3. Grep `"<leader>X` across `lua/user/*.lua` and `lua/keymaps.lua` to avoid keymap conflicts
4. Create `lua/user/<name>.lua` returning the spec table
5. Use `cmd` + `keys` fields for lazy-loading when possible

## Keymap Namespace Allocation

| Prefix | Owner |
|---|---|
| `<leader>c` | claudecode.nvim |
| `<leader>d` | DAP (debugger) |
| `<leader>e` | NvimTree toggle |
| `<leader>f` | Telescope (find files/grep/buffers/projects) |
| `<leader>g` | Git (lazygit) |
| `<leader>h` | Clear search highlights |
| `<leader>l` | LSP actions (format, rename, code action, diagnostics) |
| `<leader>/` | Toggle comment |
| `<C-]>` | ToggleTerm |
| `<C-h/j/k/l>` | Window navigation (normal + terminal mode) |

Terminal-mode keymaps: normal-mode keymaps don't fire inside terminal buffers. Use `mode = { "n", "t" }` for keymaps that must work from inside a terminal split.

## Formatting

StyLua is configured (`.stylua.toml`): 120 col width, 2-space indent, double quotes, Unix line endings, `no_call_parentheses = true` (omit parens on single-string/table-arg calls like `require "foo"`).

## Key Details

- Colorscheme: `darcula-solid` (loaded eagerly with `priority = 1000`)
- Completion: nvim-cmp with sources: LSP, lua, luasnip, buffer, path
- ToggleTerm: float by default, lazygit exposed via `_LAZYGIT_TOGGLE()` global
- Diagnostics: virtual text disabled, signs + underline + floating windows enabled
